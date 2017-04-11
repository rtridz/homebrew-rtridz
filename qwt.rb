class Qwt < Formula
  desc "Qt Widgets for Technical Applications"
<<<<<<< Updated upstream
  homepage "https://qwt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qwt/qwt/6.1.3/qwt-6.1.3.tar.bz2"
  sha256 "f3ecd34e72a9a2b08422fb6c8e909ca76f4ce5fa77acad7a2883b701f4309733"
=======
  homepage "http://qwt.sourceforge.net/"
    url "http://pkgs.fedoraproject.org/repo/pkgs/qwt-doc/qwt-5.2.1.tar.bz2/4a595b8db0ec3856b117836c1d60cb27/qwt-5.2.1.tar.bz2"
    sha256 "e2b8bb755404cb3dc99e61f3e2d7262152193488f5fbe88524eb698e11ac569f"

>>>>>>> Stashed changes
  revision 3

  bottle do
    sha256 "c27465d6fa732f966ab1f8c6acde2fa331028e7b2c4c50124970c5ffedad8bb6" => :sierra
    sha256 "287b3aa35bd3925a61d867ea9a122c04deee767cd587719fd11282f5f1cd171c" => :el_capitan
    sha256 "b5d6c8c36a6090a8dd4aa0172b64389c27e973d3bfc6ae20c030d353fbd8ab34" => :yosemite
  end

  option "with-qwtmathml", "Build the qwtmathml library"
  option "without-plugin", "Skip building the Qt Designer plugin"

  depends_on "cartr/qt4/qt"

  # Update designer plugin linking back to qwt framework/lib after install
  # See: https://sourceforge.net/p/qwt/patches/45/
  patch :DATA

  def install
    inreplace "qwtconfig.pri" do |s|
      s.gsub! /^\s*INSTALLBASE\s*=(.*)$/, "INSTALLBASE=#{prefix}"
      # s.sub! /\+(=\s*QwtDesigner)/, "-\\1" if build.without? "plugin"
    #
    #   # Install Qt plugin in `lib/qt5/plugins/designer`, not `plugins/designer`.
      # s.sub! "/usr/local/lib/qt/plugins/designer"
    end

    # args = ["-config", "release"]
    # # On Mavericks we want to target libc++, this requires a unsupported/macx-clang-libc++ flag
    # if ENV.compiler == :clang && MacOS.version >= :mavericks
    #   args << "macx-clang"
    # else
    #   args << "macx-g++"
    # end
    #
    # if build.with? "qwtmathml"
    #   args << "QWT_CONFIG+=QwtMathML"
    #   prefix.install "textengines/mathml/qtmmlwidget-license"
    # end

    system "qmake"
    system "make"
    system "make", "install"
  end

  def caveats
    s = ""

    if build.with? "qwtmathml"
      s += <<-EOS.undent
        The qwtmathml library contains code of the MML Widget from the Qt solutions package.
        Beside the Qwt license you also have to take care of its license:
        #{opt_prefix}/qtmmlwidget-license
      EOS
    end

    s
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <qwt_plot_curve.h>
      int main() {
        QwtPlotCurve *curve1 = new QwtPlotCurve("Curve 1");
        return (curve1 == NULL);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "out",
      "-std=c++11",
      "-framework", "qwt", "-framework", "QtCore",
      "-F#{lib}", "-F#{Formula["qt"].opt_lib}",
      "-I#{lib}/qwt.framework/Headers",
      "-I#{Formula["qt"].opt_lib}/QtCore.framework/Versions/4/Headers",
      "-I#{Formula["qt"].opt_lib}/QtGui.framework/Versions/4/Headers"
    system "./out"
  end
end

__END__
