class Cdo < Formula
  desc "Operators to manipulate and analyse climate and NWP model data"
  homepage "https://code.zmaw.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/20826/cdo-1.9.8.tar.gz"
  sha256 "f2660ac6f8bf3fa071cf2a3a196b3ec75ad007deb3a782455e80f28680c5252a"

  option "with-grib2", "Compile Fortran bindings"
  option "with-openmp", "Compile with OpenMP support"
  deprecated_option "enable-grib2" => "with-grib2"
  if build.with? "grib2"
    depends_on "grib-api"
    depends_on "jasper"
  end

  # needs :openmp if build.with? "openmp"
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

    if build.with? "grib2"
      args << "--with-grib_api=#{Formula["grib-api"].opt_prefix}"
      args << "--with-jasper=#{Formula["jasper"].opt_prefix}"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/cdo", "-h"
  end
end
