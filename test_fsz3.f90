program test_fsz3
    use, intrinsic :: iso_c_binding
    use :: fsz3
    implicit none
  
    integer, parameter :: iunit = 99
    integer(c_int) :: ios, datatype
    real(c_double), allocatable, target :: inbuf(:)
    real(c_double), allocatable :: diff(:)
    real(c_double), pointer :: dec_data(:)
    integer(c_size_t) :: dimx, dimy, dimz
    type(c_ptr) :: ptr_in, ptr_comp, ptr_out, file
    real(c_double) :: abserrbound, relboundratio, pwrboundratio, data_range, max_diff
    integer(c_int) :: errboundmode
    integer(c_size_t) :: outsize, ierr
    integer(c_size_t) :: r5, r4, r3, r2, r1
    integer(c_signed_char), allocatable, target :: comp_data(:)

    interface
    subroutine c_free(ptr) bind(c, name="free")
      import :: c_ptr
      implicit none
      type(c_ptr), value :: ptr
    end subroutine c_free

    function c_fclose(filepointer) bind(c, name = 'fclose')
      import:: c_ptr,c_int
      implicit none
      type(c_ptr), value  :: filepointer
      integer(c_int) :: c_fclose
    end function c_fclose
 
    function c_fopen(filename, modus)bind(c, name = 'fopen')
      import::  c_ptr, c_char
      implicit none
      type(c_ptr) :: c_fopen
      character(kind= c_char), intent(in) :: filename(*), modus(*) 
    end function c_fopen

    function c_fwrite(datap, sizeof, n, filep) bind(c, name = 'fwrite')
      import :: c_ptr, c_size_t
      implicit none
      type(c_ptr), value :: datap, filep
      integer(c_size_t), value :: sizeof , n
      integer(c_size_t) :: c_fwrite
    end function c_fwrite

    function c_fread(datap, sizeof, n, filep) bind(c, name = 'fread')
      import :: c_ptr, c_size_t
      implicit none
      type(c_ptr), value:: datap, filep
      integer(c_size_t), value :: sizeof , n
      integer(c_size_t) :: c_fread
    end function c_fread
    end interface  

    dimx = 128
    dimy = 128
    dimz = 256

    datatype = sz_double
    abserrbound = 1.d-3
    pwrboundratio = 0.
    relboundratio = 0.
    errboundmode = 0
    r5 = 0; r4= 0
    r3 = dimx; r2 = dimy; r1 = dimz

  
    open(unit=iunit, file="/Users/oscarmojica/test_data/density_128x128x256.d64", status='old', access='stream', &
         form='unformatted', action='read', iostat=ios)
    if (ios .ne. 0) then
      write(*,*) "Error opening input file."
      stop
    end if
    allocate(inbuf(dimx*dimy*dimz), diff(dimx*dimy*dimz))
    read(iunit) inbuf(:)
    close(iunit)

    ptr_in = c_loc(inbuf(1))
    ptr_comp = sz_compress_args(datatype, ptr_in, outsize, errboundmode, abserrbound, &
                                relboundratio, pwrboundratio, r5, r4, r3, r2, r1)
    write(*,'(a,1x,f7.3)') 'compression ratio = ', float(size(inbuf)* c_sizeof(c_loc(inbuf(1))))/float(outsize)

    file = c_fopen("sz_comp.data"//c_null_char, "wb"//c_null_char)
    ierr = c_fwrite(ptr_comp, int(1, c_size_t), outsize, file)
    if (ierr .ne. outsize) stop 'error writing compressed data'
    ierr = c_fclose(file)

    allocate(comp_data(outsize))
    file = c_fopen("sz_comp.data"//c_null_char, "rb"//c_null_char)
    ierr = c_fread(c_loc(comp_data), int(1, c_size_t), outsize, file)
    if (ierr .ne. outsize) stop 'error reading compressed data'
    ierr = c_fclose(file)

    ptr_out = sz_decompress(datatype, c_loc(comp_data), outsize, r5, r4, r3, r2, r1)
    call c_f_pointer(ptr_out, dec_data, [dimx*dimy*dimz])

    data_range = maxval(inbuf) - minval(inbuf)
    diff(:) = inbuf(:) - dec_data(:)
    max_diff = maxval(abs(diff))
    write(*,'(a,1x,f14.10)') 'abs err=', max_diff

    call c_free(ptr_comp)
    call c_free(ptr_out)
    deallocate(inbuf, comp_data, diff)
end program test_fsz3