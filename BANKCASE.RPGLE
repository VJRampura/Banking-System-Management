        Dcl-f ACTLF01 usage(*input : *output : *update : *delete) keyed;
        Dcl-f TXNLF01 usage(*input : *output : *update : *delete) keyed;
        Dcl-f AUTMSTF usage(*input) keyed;
        Dcl-f BANK_DSPF workstn Sfile(DDSDTXN : RRN) Sfile(DDELTXN : RRN1);
        Dcl-s RRN packed(2:0);
        Dcl-s RRN1 packed(2:0);
        Dcl-s TRNUM packed(4:0) inz;
        Dcl-S CUR_DATE date;
        Dcl-S CUR_DATE1 date(*usa);
        Dcl-S time1 char(8);
        Dcl-S user1 char(10) inz(*user);
        dcl-s DATE1 date(*iso);


          Dow *in03 = *off;
            exfmt  DLOGIN;
            Select;
              When  *in03 = *on;
                Leave;
              Other;
                Exsr $login_sr;
            Endsl;
          Enddo;
          *inlr = *on;

          Begsr $login_sr;
            Select;
              When A_UID = *blank;
                Exsr $Clear_Ind_Sr;
                *in53 = *on;
                Leavesr;
              When afld = 'A_UID';
                Exsr $Clear_Ind_Sr;
                *in14 = *on;
                Leavesr;
              When A_PASS = *blank;
                Exsr $Clear_Ind_Sr;
                *in54 = *on;
                Leavesr;
              Other;
                Chain A_UID AUTHR;
                If USER_ID = A_UID and PASSWORD = A_PASS and
                  AUTHORITY = 'Y' and *in53 = *off and
                  *in54 = *off ;
                  Dow *in03 = *off;
                    Exfmt  DMNMENU;
                    Select;
                      When *in03 = *on;
                        Leave;
                      When *in12 = *on;
                        Exsr $Clear_Ind_Sr;
                        reset DLOGIN;
                        Leavesr;
                      Other;
                        if MM_SELECT = 1;
                          Exsr $MMSELECT1_SR;
                        Elseif MM_SELECT = 2;
                          Exsr $MMSELECT2_SR;
                        Else;
                          winmsg = '   Not Valid Option';
                          Reset MM_SELECT;
                          Exfmt msg_win ;
                        Endif;
                    Endsl;
                  Enddo;
                Else;
                  Exsr $Clear_Ind_Sr;
                  reset A_PASS;
                  winmsg = '   Unauthorized User';
                  *in14 = *on;
                  Exfmt msg_win ;
                  leavesr;
                Endif;
            Endsl;
          Endsr;

          Begsr $Clear_Ind_Sr;
            *in31 = *off ;
            *in71 = *off ;
            *in13 = *off ;
            *in14 = *off ;
            *in15 = *off ;
            *in16 = *off ;
            *in17 = *off ;
            *in18 = *off ;
            *in19 = *off ;
            *in20 = *off ;
            *in21 = *off ;
            *in22 = *off ;
            *in23 = *off ;
            *in24 = *off ;
            *in25 = *off ;
          Endsr;

          Begsr $MMSELECT1_SR;
            Dow *in03 = *off;
              Exfmt DACTMST;
              Select;
                When *in03 = *on;
                  Leave;
                When *in12 = *on;
                  Exsr $Clear_Ind_Sr;
                  Reset MM_SELECT;
                  Leavesr;
                Other;
                  If AM_SELECT = 1;
                    Exsr $AMSELECT_SR1;
                  Elseif AM_SELECT = 2;
                    Exsr $AMSELECT_SR2;
                  Elseif AM_SELECT = 3;
                    Exsr $AMSELECT_SR3;
                  Else;
                    winmsg = '   Not Valid Option';
                    Reset AM_SELECT;
                    Exfmt msg_win ;
                  Endif;
              Endsl;
            Enddo;
          Endsr;


          Begsr $AMSELECT_SR1;

            *in13 = *on;
            Dow *in03 = *off;
              Setll *Hival actlf01;
              Readp actlf01;
              AD_ACNUM = (AC_NUM + 1) ;
              AD_HEADING = 'Add New Account' ;
              Exfmt DADDACT;
              Select;
                When *in03 = *on;
                  Leave;
                When *in12 = *on;
                  Reset AM_SELECT;
                  Exsr $Clear_Ind_Sr;
                  Leavesr;
                When cfld = 'AD_ACTYPE' and *in04 = *on;
                  Exsr $AC_TYP_SR;
                  Exsr $ADD_ACC_CHECK_SR;
                Other;
                  Exsr $ADD_ACC_CHECK_SR;
                  If *in53 = *off and *in54 = *off and *in55 = *off
                    and *in56 = *off and *in57 = *off and *in58 = *off
                    and *in59 = *off and *in60 = *off and *in61 = *off
                    and *in62 = *off and *in63 = *off and *in71 = *on
                    and *in31 = *on ;

                    AC_NUM = AD_ACNUM;
                    BRANCH = AD_BRANCH;
                    AC_TYPE = AD_ACTYPE;
                    F_NAME = AD_FNAME;
                    L_NAME = AD_LNAME;
                    DOB = AD_DOB;
                    ADDRESS1 = AD_ADRES1;
                    ADDRESS2 = AD_ADRES2;
                    CITY = AD_CITY;
                    STATE = AD_STATE;
                    PIN_CODE = AD_PINCODE;
                    EMAIL = AD_EMAIL;
                    PHONE = AD_MOBILE;
                    C_DATE = %dec(CUR_DATE1);
                    C_TIME = time1;
                    C_USER = user1;
                    AC_STATUS = 'A';
                    WRITE AC_MSTR;
                    If %error();
                      winmsg = '  Something Went Wrong';
                      Reset DADDACT;
                      Exfmt msg_win ;
                      Leavesr;
                    Else;
                      winmsg = '  Successfully Submitted';
                      Reset DADDACT;
                      Exsr $Clear_Ind_Sr;
                      Exfmt msg_win ;
                    Endif;
                  Endif;
              Endsl;
            Enddo;
          Endsr;


          Begsr $AMSELECT_SR2;

            Dow *in03 = *off;
              SA_OPTION = 'EDIT';
              Reset SA_ACNUM;
              Exfmt DSELACT;
              Select;
                When *in03 = *on;
                  Leave;
                When *in12 = *on;
                  Exsr $Clear_Ind_Sr;
                  Reset AM_SELECT;
                  Leavesr;
                When SA_ACNUM <> 0 ;
                  Chain SA_ACNUM actlf01;
                  If %Found();
                    AD_ACNUM = SA_ACNUM;
                    AD_BRANCH = BRANCH ;
                    AD_ACTYPE = AC_TYPE ;
                    AD_FNAME = F_NAME ;
                    AD_LNAME = L_NAME ;
                    AD_DOB = DOB ;
                    AD_ADRES1 = ADDRESS1 ;
                    AD_ADRES2 = ADDRESS2 ;
                    AD_CITY = CITY ;
                    AD_STATE = STATE ;
                    AD_PINCODE = PIN_CODE ;
                    AD_EMAIL = EMAIL ;
                    AD_MOBILE = PHONE ;
                    Exsr $Edit_Acc_sr;
                  Else;
                    *in53 = *on;
                  Endif;
                Other;
                  *in54 = *on ;
              Endsl;
            Enddo;
          Endsr;


          Begsr $Edit_Acc_sr;
            *in13 = *on;
            Dow *in03 = *off;
              AD_HEADING = 'Edit Account' ;
              Exfmt DADDACT;
              Select;
                When *in03 = *on;
                  Leave;
                When *in12 = *on;
                  Exsr $Clear_Ind_Sr;
                  Reset SA_ACNUM;
                  Leavesr;
                When cfld = 'AD_ACTYPE' and *in04 = *on;
                  Exsr $AC_TYP_SR;
                  Exsr $ADD_ACC_CHECK_SR;
                Other;
                  Exsr $ADD_ACC_CHECK_SR;
                  If *in53 = *off and *in54 = *off and *in55 = *off
                    and *in56 = *off and *in57 = *off and *in58 = *off
                    and *in59 = *off and *in60 = *off and *in61 = *off
                    and *in62 = *off and *in63 = *off and *in71 = *on
                    and *in31 = *on ;

                    AC_NUM = AD_ACNUM;
                    BRANCH = AD_BRANCH;
                    AC_TYPE = AD_ACTYPE;
                    F_NAME = AD_FNAME;
                    L_NAME = AD_LNAME;
                    DOB = AD_DOB;
                    ADDRESS1 = AD_ADRES1;
                    ADDRESS2 = AD_ADRES2;
                    CITY = AD_CITY;
                    STATE = AD_STATE;
                    PIN_CODE = AD_PINCODE;
                    EMAIL = AD_EMAIL;
                    PHONE = AD_MOBILE;
                    UPDATE AC_MSTR;
                    If %error();
                      winmsg = '  Something Went Wrong';
                      Reset DADDACT;
                      Exfmt msg_win ;
                      Leavesr;
                    Else;
                      winmsg = '  Successfully Updated';
                      Reset DADDACT;
                      Exsr $Clear_Ind_Sr;
                      Exfmt msg_win ;
                      Leavesr;
                    Endif;
                  Endif;
              Endsl;
            Enddo;
          Endsr;

          Begsr $AMSELECT_SR3;
            Dow *in03 = *off;
              SA_OPTION = 'VIEW';
              Reset SA_ACNUM;
              Exfmt DSELACT;
              Select;
                When *in03 = *on;
                  Leave;
                When *in12 = *on;
                  Exsr $Clear_Ind_Sr;
                  Reset DADDACT;
                  Reset AM_SELECT;
                  *in32 = *off;
                  Leavesr;
                When SA_ACNUM <> 0 ;
                  Chain SA_ACNUM actlf01;
                  If %Found();
                    AD_ACNUM = SA_ACNUM;
                    AD_BRANCH = BRANCH ;
                    AD_ACTYPE = AC_TYPE ;
                    AD_FNAME = F_NAME ;
                    AD_LNAME = L_NAME ;
                    AD_DOB = DOB ;
                    AD_ADRES1 = ADDRESS1 ;
                    AD_ADRES2 = ADDRESS2 ;
                    AD_CITY = CITY ;
                    AD_STATE = STATE ;
                    AD_PINCODE = PIN_CODE ;
                    AD_EMAIL = EMAIL ;
                    AD_MOBILE = PHONE ;
                    *in32 = *on;
                    AD_HEADING = 'View Account' ;
                    Exfmt DADDACT;
                    Reset DADDACT;
                  Else;
                    *in53 = *on;
                  Endif;
                Other;
                  *in54 = *on ;
              Endsl;
            Enddo;
          Endsr;


         Begsr $ADD_ACC_CHECK_SR;

          //Check_For_Account_Type......................

            If AD_ACTYPE = *blank;
              Exsr $Clear_Ind_Sr;
              *In53 = *on;
              *In13 = *on;
              Leavesr;
            Endif;

            If CFLD = 'AD_ACTYPE';
              Exsr $Clear_Ind_Sr;
              *in14 = *on;
              Leavesr;
            Endif;

          //Check_For_Branch.......................

            If AD_BRANCH = *blank;
              Exsr $Clear_Ind_Sr;
              *In54 = *on;
              *In14 = *on;
              Leavesr;
            Endif;

            If (%check('abcdefghijklmnopqrstuvwxyz ': %trim(AD_BRANCH)) <> 0);
              Exsr $Clear_Ind_Sr;
              *In54 = *on;
              *In14 = *on;
              Leavesr;
            Endif;

            If CFLD = 'AD_BRANCH';
              Exsr $Clear_Ind_Sr;
              *in15 = *on;
              Leavesr;
            Endif;

          //Check_For_Dob.............................

            If AD_DOB = *zero;
              Exsr $Clear_Ind_Sr;
              *In55 = *on;
              *In15 = *on;
              Leavesr;
            Endif;



            Test(de) *usa AD_DOB ;
            If %error;
              Exsr $Clear_Ind_Sr;
              *in55 = *on;
              *in15 = *on;
              Leavesr;
            Endif;
            time1 = %char(%time():*ISO);
            DATE1 = (%date(%char(%date(AD_DOB:*usa):*iso)));

          //Check_For_not greater than current date......
              CUR_DATE = %DATE();
              CUR_DATE1 = CUR_DATE;
                If DATE1 > CUR_DATE ;
                  *In55 = *on;
                  *In15 = *on;
                  Leavesr;
                Endif;

                If CFLD = 'AD_DOB';
                  Exsr $Clear_Ind_Sr;
                  *in16 = *on;
                  Leavesr;
                Endif;


          //Check_For_First_Name.......................

            If AD_FNAME = *blank;
              Exsr $Clear_Ind_Sr;
              *In56 = *on;
              *In16 = *on;
              Leavesr;
            Endif;

            If %check('abcdefghijklmnopqrstuvwxyz ': %trim(AD_FNAME)) <> 0 ;
              Exsr $Clear_Ind_Sr;
              *In56 = *on;
              *In16 = *on;
              Leavesr;
            Endif;

            If CFLD = 'AD_FNAME';
              Exsr $Clear_Ind_Sr;
              *in17 = *on;
              Leavesr;
            Endif;

          //Check_for_pincode.....................

                If AD_PINCODE = *zero;
                  Exsr $Clear_Ind_Sr;
                  *In57 = *on;
                  *In17 = *on;
                  Leavesr;
                Endif;

                If CFLD = 'AD_PINCODE';
                  Exsr $Clear_Ind_Sr;
                  *in18 = *on;
                  Leavesr;
                Endif;

          //Check_For_Last_Name.......................

            If AD_LNAME = *blank;
              Exsr $Clear_Ind_Sr;
              *In58 = *on;
              *In18 = *on;
              Leavesr;
            Endif;

            If %check('abcdefghijklmnopqrstuvwxyz ': %trim(AD_LNAME)) <> 0 ;
              Exsr $Clear_Ind_Sr;
              *In58 = *on;
              *In18 = *on;
              Leavesr;
            Endif;

            If CFLD = 'AD_LNAME';
              Exsr $Clear_Ind_Sr;
              *in19 = *on;
              Leavesr;
            Endif;

          //Check_For_Mobile_No..................

                If AD_MOBILE = *zero;
                  Exsr $Clear_Ind_Sr;
                  *In59 = *on;
                  *In19 = *on;
                  Leavesr;
                Endif;

                If CFLD = 'AD_MOBILE';
                  Exsr $Clear_Ind_Sr;
                  *in20 = *on;
                  Leavesr;
                Endif;


          //Check_For_City..........................

            If AD_CITY = *blank;
              Exsr $Clear_Ind_Sr;
              *In60 = *on;
              *In20 = *on;
              Leavesr;
            Endif;

            If CFLD = 'AD_CITY';
              Exsr $Clear_Ind_Sr;
              *in21 = *on;
              Leavesr;
            Endif;


          //Check_For_State..........................

            If AD_STATE = *blank;
              Exsr $Clear_Ind_Sr;
              *In61 = *on;
              *In21 = *on;
              Leavesr;
            Endif;

            If CFLD = 'AD_STATE';
              Exsr $Clear_Ind_Sr;
              *in22 = *on;
              Leavesr;
            Endif;

          //Check_for_Address..............................

                If AD_ADRES1 = *blank;
                  Exsr $Clear_Ind_Sr;
                  *In62 = *on;
                  *In22 = *on;
                  Leavesr;
                Endif;

                If CFLD = 'AD_ADRES1';
                  Exsr $Clear_Ind_Sr;
                  *in23 = *on;
                  Leavesr;
                Endif;

                If CFLD = 'AD_ADRES2';
                  Exsr $Clear_Ind_Sr;
                  *in24 = *on;
                  Leavesr;
                Endif;

          //Check_For_Valid_Email..................

                If AD_EMAIL = *blank;
                  Exsr $Clear_Ind_Sr;
                  *In63 = *on;
                  *In24 = *on;
                  Leavesr;
                Endif;

                If CFLD = 'AD_EMAIL';
                  Exsr $Clear_Ind_Sr;
                  *in31 = *on;
                  Leavesr;
                Endif;

                If CFLD = 'SUBMIT';
                  Exsr $Clear_Ind_Sr;
                  *in31 = *on;
                  *in71 = *on;
                  Leavesr;
                Endif;
         Endsr;


         Begsr $AC_TYP_SR;
            *In04 = *off;
            Exfmt AC_TYP;
            If Gen = 1;
              AD_ACTYPE = 'SV';
            Elseif gen = 2;
              AD_ACTYPE = 'CR';
            Elseif gen = 3;
              AD_ACTYPE = 'RD';
            Elseif gen = 4;
              AD_ACTYPE = 'FD';
            Endif;
          Endsr;


          Begsr $MMSELECT2_SR;

            Dow *in03 = *off;
              Exfmt DTXNMST;
              Select;
                When *in03 = *on;
                  Leave;
                When *in12 = *on;
                  Reset MM_SELECT;
                  Exsr $Clear_Ind_Sr;
                  Leavesr;
                Other;
                  If TM_SELECT = 1;
                    Exsr $TMSELECT_SR1;
                  Elseif TM_SELECT = 2;
                    Exsr $TMSELECT_SR2;
                  Elseif TM_SELECT = 3;
                    Exsr $TMSELECT_SR3;
                  Elseif TM_SELECT = 4;
                    Exsr $TMSELECT_SR4;
                  Else;
                    winmsg = '   Not Valid Option';
                    Reset TM_SELECT;
                    Exfmt msg_win ;
                  Endif;
              Endsl;
            Enddo;

          Endsr;


          Begsr $TMSELECT_SR1;

            *in13 = *on;
            Reset DADDTXN;
            Dow *in03 = *off;
              AT_HEADING = 'Add Transaction' ;
              Exfmt DADDTXN;
              Select;
                When *in03 = *on;
                  Leave;
                When *in12 = *on;
                  Exsr $Clear_Ind_Sr;
                  Reset TM_SELECT;
                  Leavesr;
                When bfld = 'AT_TTYPE' and *in04 = *on;
                  Exsr $AT_TYP_SR;
                  Exsr $ADD_TRN_CHECK_SR;
                Other;
                  Exsr $ADD_TRN_CHECK_SR;
                  If *in53 = *off and *in54 = *off and *in55 = *off
                    and *in56 = *off and *in57 = *off and *in58 = *off
                    and *in59 = *off and *in60 = *off and *in61 = *off
                    and  *in71 = *on and *in31 = *on ;

                    Setgt (AT_ACNUM) TXNLF01;
                    Readp TXNLF01;
                    if T_ACNUM = AT_ACNUM;
                      TRNUM = (TR_NUM + 1) ;
                    else;
                      TRNUM = 1 ;
                    endif;
                    TR_NUM = TRNUM;
                    T_ACNUM = AT_ACNUM;
                    TR_BRANCH = AT_TBRANCH;
                    TR_TYPE = AT_TTYPE;
                    TR_DATE = AT_TDATE;
                    TR_AMOUNT = AT_TAMOUNT;
                    F_ACCOUNT = AT_FACNT;
                    T_ACCOUNT = AT_TOACNT;
                    TR_STATUS = AT_TSTATUS;
                    TR_TIME = %CHAR(AT_TTIME);
                    CR_DATE = %dec(CUR_DATE1);
                    CR_TIME = time1;
                    C_USER = user1;
                    AC_STATUS = 'A';
                    WRITE TC_MSTR;
                    If %error();
                      winmsg = '  Something Went Wrong';
                      Reset DADDTXN;
                      Exfmt msg_win ;
                      Leavesr;
                    Else;
                      winmsg = '  Successfully Submitted';
                      Reset DADDTXN;
                      Exsr $Clear_Ind_Sr;
                      Exfmt msg_win ;
                    Endif;
                  Endif;
              Endsl;
            Enddo;

          Endsr;


          Begsr $ADD_TRN_CHECK_SR;
            time1 = %char(%time():*ISO);
          //Check_For_Account_NUMBER......................

            If AT_ACNUM = *zero;
              Exsr $Clear_Ind_Sr;
              *In53 = *on;
              *In13 = *on;
              Leavesr;
            Endif;

            Chain (AT_ACNUM) actlf01 ;
            if not %found();
              Exsr $Clear_Ind_Sr;
              *In53 = *on;
              *In13 = *on;
              Leavesr;
            Endif;

            If BFLD = 'AT_ACNUM';
              Exsr $Clear_Ind_Sr;
              *in14 = *on;
              Leavesr;
            Endif;

          //Check_For_Transaction_Type......................

            If AT_TTYPE = *blank;
              Exsr $Clear_Ind_Sr;
              *In54 = *on;
              *In14 = *on;
              Leavesr;
            Endif;

            If BFLD = 'AT_TTYPE';
              Exsr $Clear_Ind_Sr;
              *in15 = *on;
              Leavesr;
            Endif;

            //Check_For_Transaction_Date.............................

            If AT_TDATE = *zero;
              Exsr $Clear_Ind_Sr;
              *In55 = *on;
              *In15 = *on;
              Leavesr;
            Endif;



            Test(de) *usa AT_TDATE ;
            If %error;
              Exsr $Clear_Ind_Sr;
              *in55 = *on;
              *in15 = *on;
              Leavesr;
            Endif;

           DATE1 = (%date(%char(%date(AT_TDATE:*usa):*iso)));


          //Check_For_not greater than current date......

              CUR_DATE = %DATE();
              CUR_DATE1 = CUR_DATE;
                If DATE1 > CUR_DATE ;
                  *In55 = *on;
                  *In15 = *on;
                  Leavesr;
                Endif;

                If BFLD = 'AT_TDATE';
                  Exsr $Clear_Ind_Sr;
                  *in16 = *on;
                  Leavesr;
                Endif;

          //Check_For_Transaction_Amount......................

            If AT_TAMOUNT = *zero;
              Exsr $Clear_Ind_Sr;
              *In56 = *on;
              *In16 = *on;
              Leavesr;
            Endif;

            If BFLD = 'AT_TAMOUNT';
              Exsr $Clear_Ind_Sr;
              *in17 = *on;
              Leavesr;
            Endif;

          //Check_For_Transaction_Time......................

            If AT_TTIME = *blank;
              Exsr $Clear_Ind_Sr;
              *In57 = *on;
              *In17 = *on;
              Leavesr;
            Endif;



            Test(ET) *iso AT_TTIME ;
            If %error;
              Exsr $Clear_Ind_Sr;
              *in57 = *on;
              *in17 = *on;
              Leavesr;
            Endif;

            If BFLD = 'AT_TTIME';
              Exsr $Clear_Ind_Sr;
              *in18 = *on;
              Leavesr;
            Endif;

            //Check_For_Transaction_Branch.......................

            If AT_TBRANCH = *blank;
              Exsr $Clear_Ind_Sr;
              *In58 = *on;
              *In18 = *on;
              Leavesr;
            Endif;

            If (%check('abcdefghijklmnopqrstuvwxyz ': %trim(AT_TBRANCH)) <> 0);
              Exsr $Clear_Ind_Sr;
              *In58 = *on;
              *In18 = *on;
              Leavesr;
            Endif;

            If BFLD = 'AT_TBRANCH';
              Exsr $Clear_Ind_Sr;
              *in19 = *on;
              Leavesr;
            Endif;

            //Check_For_From_Account......................

            If AT_FACNT = *zero;
              Exsr $Clear_Ind_Sr;
              *In59 = *on;
              *In19 = *on;
              Leavesr;
            Endif;

            Chain (AT_FACNT) actlf01 ;
            if not %found();
              Exsr $Clear_Ind_Sr;
              *In59 = *on;
              *In19 = *on;
              Leavesr;
            Endif;

            if (AT_TTYPE = 'CR' and AT_FACNT = AT_ACNUM) Or
               (AT_TTYPE = 'DB' and AT_FACNT <> AT_ACNUM) ;
              Exsr $Clear_Ind_Sr;
              *In63 = *on;
              *In19 = *on;
              Leavesr;
            Endif;

            If BFLD = 'AT_FACNT';
              Exsr $Clear_Ind_Sr;
              *in20 = *on;
              Leavesr;
            Endif;

            //Check_For_To_Account......................

            If AT_TOACNT = *zero;
              Exsr $Clear_Ind_Sr;
              *In60 = *on;
              *In20 = *on;
              Leavesr;
            Endif;

            If AT_TOACNT = AT_FACNT;
              Exsr $Clear_Ind_Sr;
              *In60 = *on;
              *In20 = *on;
              Leavesr;
            Endif;

            Chain (AT_TOACNT) actlf01 ;
            if not %found();
              Exsr $Clear_Ind_Sr;
              *In60 = *on;
              *In20 = *on;
              Leavesr;
            Endif;

            if (AT_TTYPE = 'CR' and AT_TOACNT <> AT_ACNUM) Or
               (AT_TTYPE = 'DB' and AT_TOACNT = AT_ACNUM) ;
              Exsr $Clear_Ind_Sr;
              *In64 = *on;
              *In20 = *on;
              Leavesr;
            Endif;

            If BFLD = 'AT_TOACNT';
              Exsr $Clear_Ind_Sr;
              *in21 = *on;
              Leavesr;
            Endif;

          //Check_For_Transaction_Status......................

            If AT_TSTATUS = *blank;
              Exsr $Clear_Ind_Sr;
              *In61 = *on;
              *In21 = *on;
              Leavesr;
            Endif;

            If BFLD = 'AT_TSTATUS';
              Exsr $Clear_Ind_Sr;
              *in31 = *on;
              Leavesr;
            Endif;

            If BFLD = 'SUBMIT';
              Exsr $Clear_Ind_Sr;
              *in31 = *on;
              *in71 = *on;
              Leavesr;
            Endif;
          Endsr;


          Begsr $AT_TYP_SR;
            *In04 = *off;
            Exfmt TN_TYP;
            If TNT = 1;
              AT_TTYPE = 'CR';
            Elseif TNT = 2;
              AT_TTYPE = 'DB';
            Endif;
          Endsr;



          Begsr $TMSELECT_SR2;
            *in13 = *on;
            Dow *in03 = *off;
              Exfmt DSELTXN;
                Select;
                  When *in03 = *on;
                    Leave;
                  When *in12 = *on;
                    Reset TM_SELECT;
                    Exsr $Clear_Ind_Sr;
                    Leavesr;
                  Other;
                    Exsr $acc_trn_check_sr;
                    If *in53 = *off and *in54 = *off and *in31 = *on and
                      *in71 = *on;
                      Exsr $Clear_Ind_Sr;
                      Exsr $Edit_trn_sr;
                    Endif;
                Endsl;
            Enddo;
          Endsr;


          Begsr $acc_trn_check_sr;
            if ET_ACNUM = *zero;
              Exsr $Clear_Ind_Sr;
              *In53 = *on;
              *In13 = *on;
              Leavesr;
            Endif;

            Chain (ET_ACNUM) TXNLF01;
            If not %found();
              Exsr $Clear_Ind_Sr;
              *In53 = *on;
              *In13 = *on;
              Leavesr;
            Endif;


            If AFLD = 'ET_ACNUM';
              Exsr $Clear_Ind_Sr;
              *in14 = *on;
              Leavesr;
            Endif;

            if ET_TRNUM = *zero;
              Exsr $Clear_Ind_Sr;
              *In54 = *on;
              *In14 = *on;
              Leavesr;
            Endif;

            Chain (ET_ACNUM : ET_TRNUM) TXNLF01;
            If not %found();
              Exsr $Clear_Ind_Sr;
              *In54 = *on;
              *In14 = *on;
              Leavesr;
            Endif;

            If AFLD = 'ET_TRNUM';
              Exsr $Clear_Ind_Sr;
              *in31 = *on;
              Leavesr;
            Endif;

            If AFLD = 'ENTER';
              Exsr $Clear_Ind_Sr;
              *in31 = *on;
              *in71 = *on;
              Leavesr;
            Endif;

          Endsr;

          Begsr $Edit_trn_sr;
              Chain (ET_ACNUM : ET_TRNUM) TXNLF01;
              TRNUM = TR_NUM ;
              AT_ACNUM = T_ACNUM;
              AT_TBRANCH = TR_BRANCH;
              AT_TTYPE = TR_TYPE;
              AT_TDATE = TR_DATE;
              AT_TAMOUNT = TR_AMOUNT;
              AT_FACNT = F_ACCOUNT;
              AT_TOACNT = T_ACCOUNT;
              AT_TSTATUS = TR_STATUS;
              AT_TTIME = TR_TIME;
            dow *in03 = *off;
              AT_HEADING = 'Edit Transaction' ;
              *in51 = *on;
              Exfmt DADDTXN;
              Select;
                When *in03 = *on;
                  Leave;
                When *in12 = *on;
                  Reset DSELTXN;
                  *in51 = *off;
                  Exsr $Clear_Ind_Sr;
                  Leavesr;
                Other;
                  Exsr $ADD_TRN_CHECK_SR;
                  If *in53 = *off and *in54 = *off and *in55 = *off
                    and *in56 = *off and *in57 = *off and *in58 = *off
                    and *in59 = *off and *in60 = *off and *in61 = *off
                    and  *in71 = *on and *in31 = *on ;
                    T_ACNUM = AT_ACNUM;
                    TR_BRANCH = AT_TBRANCH;
                    TR_TYPE = AT_TTYPE;
                    TR_DATE = AT_TDATE;
                    TR_AMOUNT = AT_TAMOUNT;
                    F_ACCOUNT = AT_FACNT;
                    T_ACCOUNT = AT_TOACNT;
                    TR_STATUS = AT_TSTATUS;
                    TR_TIME = %CHAR(AT_TTIME);
                    UPDATE TC_MSTR;
                    If %error();
                      winmsg = '  Something Went Wrong';
                      Reset DADDTXN;
                      Exfmt msg_win ;
                      Leavesr;
                    Else;
                      winmsg = '  Successfully Updated';
                      Reset DADDTXN;
                      Reset DSELTXN;
                      Exsr $Clear_Ind_Sr;
                      Exfmt msg_win ;
                      Leavesr;
                    Endif;
                  Endif;
              Endsl;
            enddo;
          Endsr;




          Begsr $TMSELECT_SR3;
             Dow *in03 = *off;
              DT_HEADING = 'View Transaction' ;
              Exfmt DDSPTXN;
                Select;
                  When *in03 = *on;
                    Leave;
                  When *in12 = *on;
                    Reset TM_SELECT;
                    Exsr $Clear_Ind_Sr;
                    Leavesr;
                  When DT_ACNUM = *zero ;
                    Exsr $Clear_Ind_Sr;
                    *In53 = *on;
                  Other;
                    Chain (DT_ACNUM) TXNLF01;
                    If %found();
                      Exsr $clear_sfl_sr;
                      Exsr $load_sfl_sr;
                      Exsr $dspl_sfl_sr;
                    Else;
                      winmsg = '  Invalid A/c Number';
                      Reset DT_ACNUM;
                      Exfmt msg_win ;
                    Endif;
                Endsl;
            Enddo;
          Endsr;

          Begsr $clear_sfl_sr;
            *in02 = *off;
            Write DDSDTXNC;
            *in02 = *on;
            rrn = 0;
          Endsr;

          Begsr $load_sfl_sr;
            Setll (DT_ACNUM) TXNLF01;
            Read TXNLF01;
              dow not %eof();
                If T_ACNUM = DT_ACNUM;
                  rrn = rrn + 1 ;
                  VT_ACNO = T_ACNUM;
                  VT_TNO = TR_NUM;
                  VT_TDATE = TR_DATE;
                  VT_TTYPE = TR_TYPE;
                  VT_TAMT = TR_AMOUNT;
                  VT_TIME = TR_TIME;
                  VT_STS = TR_STATUS;
                  VT_BRANCH = TR_BRANCH;
                  Write DDSDTXN;
                endif;
                read TXNLF01;
              Enddo;
          Endsr;

          Begsr $dspl_sfl_sr;
            *in32 = *on;
            Write footer ;
            Exfmt DDSDTXNC;
            Reset DT_ACNUM;
            *in32 = *off;
          Endsr;




          Begsr $TMSELECT_SR4;
             Dow *in03 = *off;
              DT_HEADING = 'Delete Transactions' ;
              Exfmt DDSPTXN;
                Select;
                  When *in03 = *on;
                    Leave;
                  When *in12 = *on;
                    Reset TM_SELECT;
                    Exsr $Clear_Ind_Sr;
                    Leavesr;
                  When DT_ACNUM = *zero ;
                    Exsr $Clear_Ind_Sr;
                    *In53 = *on;
                  Other;
                    Chain (DT_ACNUM) TXNLF01;
                    If %found();
                      Exsr $delete_trn_sr;
                    Else;
                      winmsg = '  Invalid A/c Number';
                      Reset DT_ACNUM;
                      Exfmt msg_win ;
                    Endif;
                Endsl;
            Enddo;
          Endsr;

          Begsr $clear_dlt_sfl_sr;
            *in06 = *off;
            Write DDELTXNC;
            *in06 = *on;
            rrn1 = 0;
          Endsr;

          Begsr $load_dlt_sfl_sr;
            Setll (DT_ACNUM) TXNLF01;
            Read TXNLF01;
              dow not %eof();
                If T_ACNUM = DT_ACNUM;
                  rrn1 = rrn1 + 1 ;
                  DT_TDATE = TR_DATE;
                  DT_TTYPE = TR_TYPE;
                  DT_TAMT = TR_AMOUNT;
                  DT_BRANCH = TR_BRANCH;
                  DT_FACNT = F_ACCOUNT;
                  DT_TACNT = T_ACCOUNT;
                  DT_TNO = TR_NUM;
                  Write DDELTXN;
                endif;
                read TXNLF01;
              Enddo;
          Endsr;


          Begsr $dspl_dlt_sfl_sr;
            Write footer ;
            Exfmt DDELTXNC;
            //Reset DT_ACNUM;
          Endsr;



          Begsr $delete_trn_sr;
            Dow *in03 = *off;
              Exsr $clear_dlt_sfl_sr;
              Exsr $load_dlt_sfl_sr;
              Exsr $dspl_dlt_sfl_sr;

              If *in12 = *on;
                Reset DT_ACNUM;
                Leavesr;
              Else;
                Readc DDELTXN;
                *IN01 = *ON;
                DOW NOT %EOF();
                  if DT_OPT = 'D';
                      Chain (DT_ACNUM : DT_TNO) TC_MSTR;
                      DELETE TC_MSTR;
                      if not %error();
                        winmsg = '  Successfully Deleted';
                        Exfmt msg_win ;
                      Endif;
                  Elseif DT_OPT = 'N';
                    Reset DT_ACNUM;
                    Leavesr;
                  Endif;
                  Readc DDELTXN;
                Enddo;
                *In01 = *Off;
                Reset DT_OPT;
              Endif;
            Enddo;
          Endsr;

