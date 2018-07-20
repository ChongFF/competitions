OPTIONS MPRINT MLOGIC SYMBOLGEN;
%LET sampling_rate = 0.10;
PROC IMPORT DATAFILE="S:\ACTUARY3\Advanced Analytics\Private\Staff\Chong, Fan Fei\arch_kaggle_data\in\application_train.csv"
     OUT=train;
RUN;
DATA train_test_samp;
    SET train;
	CALL STREAMINIT(459321);
	test_ind = (flag_document_2 + flag_document_19+flag_document_20+flag_document_21+flag_document_17+flag_document_16+flag_document_14
	+flag_document_13+flag_document_12+flag_document_15+flag_document_10 = 0);
	IF (ext_source_2 = . AND ext_source_1 NE .) OR (ext_source_2 = . AND (ext_source_3 NE . OR ext_source_3 < 0.24 OR ext_source_3 > 0.28)) THEN test_ind = 0;
	IF name_contract_type = 'Revolving loans' AND RAND('UNIFORM') > 0.10 THEN test_ind = 0;
RUN;
PROC MEANS DATA=train_test_samp;
    VAR test_ind;
RUN;
PROC FREQ DATA=train_test_samp(WHERE = (test_ind = 1));
    TABLE name_contract_type;
RUN;
DATA train_weighted valid_weighted;
    SET train_test_samp(DROP = SK_ID_CURR);
	CALL STREAMINIT(459321);
	IF test_ind THEN weight = MIN(1/RAND('uniform'),50-12.5*RAND('uniform'));
	    ELSE weight = RAND('uniform');
	split = INT(5*RAND('uniform'))+1;
	IF RAND('uniform') > &sampling_rate THEN DELETE;			/**/
	IF split < 5 THEN OUTPUT train_weighted;
	    ELSE OUTPUT valid_weighted;
RUN;
PROC UNIVARIATE DATA=train_weighted ;
    VAR weight;
	HISTOGRAM;
RUN;
%ds2csv (data=train_weighted, runmode=b, csvfile=
        %STR(S:\ACTUARY3\Advanced Analytics\Private\Staff\Chong, Fan Fei\arch_kaggle_data\out\train_weighted.csv));
%ds2csv (data=valid_weighted, runmode=b, csvfile=
        %STR(S:\ACTUARY3\Advanced Analytics\Private\Staff\Chong, Fan Fei\arch_kaggle_data\out\valid_weighted.csv));
