module fsz3
    use, intrinsic :: iso_c_binding
    implicit none
    private
  
    ! Define C data types
    integer(c_int), public, parameter :: SZ_FLOAT = 0
    integer(c_int), public, parameter :: SZ_DOUBLE = 1
    integer(c_int), public, parameter :: SZ_UINT8 = 2
    integer(c_int), public, parameter :: SZ_INT8 = 3
    integer(c_int), public, parameter :: SZ_UINT16 = 4
    integer(c_int), public, parameter :: SZ_INT16 = 5
    integer(c_int), public, parameter :: SZ_UINT32 = 6
    integer(c_int), public, parameter :: SZ_INT32 = 7
    integer(c_int), public, parameter :: SZ_UINT64 = 8
    integer(c_int), public, parameter :: SZ_INT64 = 9

    public ::  sz_compress_args
    public ::  sz_decompress

    ! Define C function interfaces
    interface
    function sz_compress_args(datatype, data, outsize, errboundmode, abserrbound, relboundratio, pwrboundratio, &
                              r5, r4, r3, r2, r1) bind(c, name="SZ_compress_args")
      import :: c_size_t, c_double, c_int, c_ptr
      implicit none
      type(c_ptr), value :: data
      integer(c_int), value :: datatype
      real(c_double), value :: abserrbound, relboundratio, pwrboundratio
      integer(c_int), value :: errboundmode
      integer(c_size_t) :: outsize
      integer(c_size_t), value :: r5, r4, r3, r2, r1
      type(c_ptr) :: sz_compress_args
    end function sz_compress_args

    function sz_decompress(datatype, bytes, bytelength, r5, r4, r3, r2, r1) bind(c, name="SZ_decompress")
      import :: c_size_t, c_int, c_ptr
      implicit none
      type(c_ptr), value :: bytes
      integer(c_int), value :: datatype
      integer(c_size_t), value :: bytelength
      integer(c_size_t), value :: r5, r4, r3, r2, r1
      type(c_ptr) :: sz_decompress
    end function sz_decompress
    end interface

end module fsz3
