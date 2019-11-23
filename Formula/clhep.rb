class Clhep < Formula
  desc "C++ Class Library for High Energy Physics"
  homepage "http://proj-clhep.web.cern.ch/proj-clhep/"
  revision 1

  stable do
    url "http://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.1.3.tgz"
    sha256 "27c257934929f4cb1643aa60aeaad6519025d8f0a1c199bc3137ad7368245913"
  end

  # devel do
  #   url "http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.3.1.0.tgz"
  #   sha256 "66272ae3100d3aec096b1298e1e24ec25b80e4dac28332b45ec3284023592963"
  # end

  depends_on "cmake" => :build

  def install
    mkdir "clhep-build" do
      system "cmake", "../CLHEP", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <Vector/ThreeVector.h>

      int main() {
        CLHEP::Hep3Vector aVec(1, 2, 3);
        std::cout << "r: " << aVec.mag();
        std::cout << " phi: " << aVec.phi();
        std::cout << " cos(theta): " << aVec.cosTheta() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lCLHEP", "-I#{include}/CLHEP",
           testpath/"test.cpp", "-o", "test"
    assert_equal "r: 3.74166 phi: 1.10715 cos(theta): 0.801784",
                 shell_output("./test").chomp
  end
end

__END__
