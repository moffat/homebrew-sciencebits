class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/20826/cdo-1.9.8.tar.gz"
  sha256 "f2660ac6f8bf3fa071cf2a3a196b3ec75ad007deb3a782455e80f28680c5252a"
  revision 1

  option "with-eccodes", "Compile with ecCodes support"
  option "with-openmp", "Compile with OpenMP support"
  if build.with? "eccodes"
    depends_on "eccodes"
    depends_on "jasper"
  end

  depends_on "gcc" if build.with? "openmp"

  depends_on "hdf5"
  depends_on "netcdf"
  depends_on "szip"

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}", "LIBS=-lhdf5",
            "--with-netcdf=#{Formula["netcdf"].opt_prefix}",
            "--with-hdf5=#{Formula["hdf5"].opt_prefix}",
            "--with-szlib=#{Formula["szip"].opt_prefix}"]

    if build.with? "eccodes"
      args << "--with-eccodes=#{Formula["eccodes"].opt_prefix}"
      args << "--with-jasper=#{Formula["jasper"].opt_prefix}"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/cdo", "-h"
  end
end
