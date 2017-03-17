javaaddpath('C:\Users\thanatcha\AppData\Roaming\MathWorks\MATLAB\R2016a\postgresql-9.4.1212.jre6.jar')
conn = database('monitoring_system','hoykhomdb','A86qPz9oWnZAao8',...
             'Vendor','PostgreSQL',...
           'Server','52.230.29.224');
conn


curs = exec(conn,'select * from eaocity');
curs = fetch(curs);
curs.Data


colnames={'s2','city','zipcode'};
data = {4,'Rubik',' Cube'};
data_table = cell2table(data,'VariableNames',colnames)

tablename = 'eaocity';

fastinsert(conn,tablename,colnames,data)
curs = exec(conn,'select * from eaocity');
curs = fetch(curs);
curs.Data

close(curs)
close(conn)

