class Pyqt < Formula
  desc "Python bindings for Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "http://pkgs.fedoraproject.org/repo/pkgs/PyQt4/PyQt-x11-gpl-4.7.4.tar.gz/88e9f1bc467cccf424d2032e3470982c/PyQt-x11-gpl-4.7.4.tar.gz"
  sha256 "1900984b9fb830b8e394da338d304fa4555fa4aa0e7bc8774ea2c172eec7f128"

  option "without-python", "Build without python 2 support"
  depends_on :python3 => :optional

  if build.without?("python3") && build.without?("python")
    odie "pyqt: --with-python3 must be specified when using --without-python"
  end

  depends_on "cartr/qt4/qt"

  if build.with? "python3"
    depends_on "sip" => "with-python3"
  else
    depends_on "sip"
  end

  def install
    # On Mavericks we want to target libc++, this requires a non default qt makespec
    # if ENV.compiler == :clang && MacOS.version >= :mavericks
    #   ENV.append "QMAKESPEC", "unsupported/macx-clang-libc++"
    # end

    Language::Python.each_python(build) do |python, version|
      ENV.append_path "PYTHONPATH", "#{Formula["sip"].opt_lib}/python#{version}/site-packages"

      args = %W[
        --confirm-license
        --bindir=#{bin}
        --destdir=#{lib}/python#{version}/site-packages
        --sipdir=#{share}/sip
      ]

      # We need to run "configure.py" so that pyqtconfig.py is generated, which
      # is needed by QGIS, PyQWT (and many other PyQt interoperable
      # implementations such as the ROS GUI libs). This file is currently needed
      # for generating build files appropriate for the qmake spec that was used
      # to build Qt. The alternatives provided by configure-ng.py is not
      # sufficient to replace pyqtconfig.py yet (see
      # https://github.com/qgis/QGIS/pull/1508). Using configure.py is
      # deprecated and will be removed with SIP v5, so we do the actual compile
      # using the newer configure-ng.py as recommended. In order not to
      # interfere with the build using configure-ng.py, we run configure.py in a
      # temporary directory and only retain the pyqtconfig.py from that.

      require "tmpdir"
      dir = Dir.mktmpdir
      begin
        cp_r(Dir.glob("*"), dir)
        cd dir do
          system python, "configure.py", *args
          inreplace "pyqtconfig.py", "#{HOMEBREW_CELLAR}/#{Formula["cartr/qt4/qt"].name}/#{Formula["cartr/qt4/qt"].pkg_version}",
            Formula["cartr/qt4/qt"].opt_prefix
          (lib/"python#{version}/site-packages/PyQt4").install "pyqtconfig.py"
        end
      ensure
        remove_entry_secure dir
      end

      # On Mavericks we want to target libc++, this requires a non default qt makespec
      # if ENV.compiler == :clang && MacOS.version >= :mavericks
      #   args << "--spec" << "unsupported/macx-clang-libc++"
      # end

      system python, "configure.py", *args
      system "make"
      system "make", "install"
      system "make", "clean" # for when building against multiple Pythons
    end
  end

  def caveats
    "Phonon support is broken."
  end

  test do
    Pathname("test.py").write <<-EOS.undent
      from PyQt4 import QtNetwork
      QtNetwork.QNetworkAccessManager().networkAccessible()
    EOS

    Language::Python.each_python(build) do |python, _version|
      system python, "test.py"
    end
  end

  bottle do
    root_url "https://dl.bintray.com/cartr/bottle-qt4"
    rebuild 1
    sha256 "cea56ddfe0e96dbf87d53aaffbd4a1fda8410646d11721a6555857bc36960e8a" => :sierra
  end
end
