ob_num = 41;
obc_nodes=1:ob_num;
inpath='.\';

%% this program is used to produce the elevation using the given tidal harmonic constant 
%% at given time.
% this program needs to input the following variables;
% (start_time,interval,end_time,names,freq,tidecon,lat)
% start_time indicates the start time needs to simulate ([year month day hour minite second]);
% Greenwich Time
% interval indicates the time interval of output (unit:day);
% end_time indicates the end time needs to simulate ([year month day hour minite second]);
% lat indicates the latitude of the stations position
%------------parameters----------------------------%
start_time = datenum([2022,1,1,0,0,0]);
end_time   = datenum([2023,1,1,0,0,0]);
interval   = 1/24;
%------------parameters----------------------------%
tim = start_time:interval:end_time;
tim = tim';
time_num = length(tim);
ndays  = end_time-start_time+1;   %%%num of days

iint(1,1:time_num) = 0;
time   = tim - datenum(1858,11,17);
Itime  = floor(time);
Itime2 = 1000*mod((tim'-start_time)*86400,86400)'; % msec after a day
Times  = datestr(tim,'yyyy-mm-ddTHH:MM:SS');
hsig = zeros(time_num,ob_num);
tpek = zeros(time_num,ob_num);
wdir = zeros(time_num,ob_num);
for n = 1:ob_num
   hsig(:,n) = 0.8;    
   tpek(:,n) = 6.0;
   wdir(:,n) = 180/180*pi;
end

%=======================================================================================================
% write the nc documnet
%=======================================================================================================
output = 'wave_obc.nc';
nc_create_empty ( output );

%=======================================================================================================
% Global Attributes
%=======================================================================================================

   OPT.type                   = 'FVCOM TIME SERIES OBC WAVE FILE';
   OPT.title                  = 'This data was transformed from an old FVCOM WAVE nudging file';
   OPT.institution            = 'Ocean University of China';
   OPT.history                = 'FILE CREATED: 20221111';

   nc_attput(output, nc_global, 'type'          , OPT.type);
   nc_attput(output, nc_global, 'title'         , OPT.title);
   nc_attput(output, nc_global, 'institution'   , OPT.institution);
   nc_attput(output, nc_global, 'history'       , OPT.history);
   

%==========================================================================================================
% Dimensions
%==========================================================================================================

nc_add_dimension ( output, 'nobc', ob_num);
nc_add_dimension ( output, 'time', 0);
nc_add_dimension ( output, 'DateStrLen', 26)

%============================================================================================================
% Variables and Attributes
%============================================================================================================

varstruct.Name = 'obc_nodes';
varstruct.Datatype = 'int';
varstruct.Dimension = { 'nobc' };
nc_addvar ( output, varstruct );
nc_attput (output, 'obc_nodes', 'long_name', 'Open Boundary Node Number' );
nc_attput (output, 'obc_nodes', 'grid', 'obc_grid' );

varstruct.Name = 'iint';
varstruct.Datatype = 'int';
varstruct.Dimension = {'time'};
nc_addvar (output,varstruct);
nc_attput (output , 'iint' , 'long_name' , 'internal mode iteration number');

varstruct.Name = 'time';
varstruct.Datatype = 'single';
varstruct.Dimension = {'time'};
nc_addvar (output,varstruct);
nc_attput (output , 'time' , 'long_name' , 'time');
nc_attput (output , 'time' , 'units' , 'days since 1858-11-17 00:00:00');
nc_attput (output , 'time' , 'format' , 'modified julian day (MJD)');
nc_attput (output , 'time' , 'time_zone' , 'UTC');

varstruct.Name = 'Itime';
varstruct.Datatype = 'int';
varstruct.Dimension = {'time'};
nc_addvar (output,varstruct);
nc_attput (output , 'Itime' , 'units' , 'days since 1858-11-17 00:00:00');
nc_attput (output , 'Itime' , 'format' , 'modified julian day (MJD)');
nc_attput (output , 'Itime' , 'time_zone' , 'UTC');

varstruct.Name = 'Itime2';
varstruct.Datatype = 'int';
varstruct.Dimension = {'time'};
nc_addvar (output,varstruct);
nc_attput (output , 'Itime2' , 'units' , 'msec since 00:00:00');
nc_attput (output , 'Itime2' , 'time_zone' , 'UTC');

varstruct.Name = 'Times';
varstruct.Datatype = 'char';
varstruct.Dimension = {'time', 'DateStrLen'};
nc_addvar (output,varstruct);
nc_attput (output , 'Times' , 'time_zone' , 'UTC');

varstruct.Name = 'hsig';
varstruct.Datatype = 'single';
varstruct.Dimension = { 'time','nobc' };
nc_addvar ( output, varstruct );
nc_attput (output , 'hsig', 'long_name', 'Significant Wave Height' );
nc_attput (output , 'hsig', 'units', 'meters' );

varstruct.Name = 'tpek';
varstruct.Datatype = 'single';
varstruct.Dimension = { 'time','nobc' };
nc_addvar ( output, varstruct );
nc_attput (output , 'tpek', 'long_name', 'Peak Wave Period' );
nc_attput (output , 'tpek', 'units', 'seconds' );

varstruct.Name = 'wdir';
varstruct.Datatype = 'single';
varstruct.Dimension = { 'time','nobc' };
nc_addvar ( output, varstruct );
nc_attput (output , 'wdir', 'long_name', 'Wave Direction' );
nc_attput (output , 'wdir', 'units', 'nautical degree' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nc_varput(output ,'obc_nodes', obc_nodes);
nc_varput(output ,'iint',   iint  );
nc_varput(output ,'time',   time  );
nc_varput(output ,'Itime',  Itime );
nc_varput(output ,'Itime2', Itime2);
nc_varput(output ,'Times',  Times );
nc_varput(output ,'hsig', hsig);
nc_varput(output ,'tpek', tpek);
nc_varput(output ,'wdir', wdir);

disp(['WAVE OBC file created!']);
disp('Congratulations!');