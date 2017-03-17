javaaddpath('C:\Users\thanatcha\AppData\Roaming\MathWorks\MATLAB\R2016a\postgresql-9.4.1212.jre6.jar')
%conn = database('monitoring_system','hoykhom','kmitleslteam',...postgresql-9.4.1212.jre6
%                'Vendor','PostgreSQL',...
%                'Server','ec2-52-32-167-89.us-west-2.compute.amazonaws.com');

conn = database('monitoring_system','hoykhomdb','A86qPz9oWnZAao8',...
             'Vendor','PostgreSQL',...
           'Server','52.230.29.224');
conn

sqlquery = 'select picture,datetime from weather';
curs = exec(conn,sqlquery);
setdbprefs('DataReturnFormat','cellarray')
curs = fetch(curs);
curs.Data
close(curs)
close(conn)