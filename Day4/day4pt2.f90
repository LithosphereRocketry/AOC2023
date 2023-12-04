program readText
    ! With thanks to StackOverflow user CKE
    implicit none

    integer :: FID = 1
    character*256 :: CTMP
    integer :: I = 0, J = 0, IERR = 0, NUM_LINES = -1, VAL, SCORE, TOTAL = 0
    logical, dimension(100) :: winning
    integer, allocatable :: tickets(:)

    open(unit=FID,file='input.txt')

    do while (IERR == 0)
        NUM_LINES = NUM_LINES + 1
        read(FID,*,iostat=IERR) CTMP
    end do

    allocate(tickets(NUM_LINES))
    do I = 1, NUM_LINES
        tickets(I) = 1
    end do

    rewind(FID)
    do I = 1, NUM_LINES
        do J = 1, 100
            winning(J) = .false.
        end do
        read(FID,'(A)') CTMP
        CTMP = CTMP(index(CTMP, ':') + 2:)
        do while (CTMP(1:1) /= '|')
            if (CTMP(1:1) == ' ') then
                CTMP(1:1) = '0'
            end if
            read(CTMP(:2), *) VAL
            winning(VAL) = .true.
            CTMP = CTMP(4:)
        end do
        CTMP = CTMP(3:)
        SCORE = 0
        do while (len(trim(CTMP)) > 0)
            if (CTMP(1:1) == ' ') then
                CTMP(1:1) = '0'
            end if
            read(CTMP(:2), *) VAL
            if (winning(VAL)) then
                SCORE = SCORE + 1
            end if
            CTMP = CTMP(4:)
        end do
        do J = 1, SCORE
            tickets(I+J) = tickets(I+J) + tickets(I)
        end do
        TOTAL = TOTAL + tickets(I)
    end do
    write(*,*) TOTAL

    deallocate(tickets)
    close(FID)
end program readText