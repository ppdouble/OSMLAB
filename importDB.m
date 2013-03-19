function [DataMat] = importDB(sqlquery)
% IMPORTDB(DBase, username, password)
% Imports data into MATLAB from a database.  Assumes database is called
% 'rsc'.
% 
% 
% INPUT: (optional)
%   DBase     string containing the name of the database you're connecting to
%   username  string of the database user's name
%   password  string with user's password
% OUTPUT:
%   DataMat   a matrix of the data in the table, in cell array format
%   selCols   a string containing all the column names in order
% POSTCONDITION:
%   prints out the column headings that were selected

javaclasspath('postgresql-9.2-1002.jdbc4.jar');

nargin = 1;

if (nargin == 0)
    DBase = 'osm';
    username = 'bharatkunwar'; %username = '';
    password = ''; %password = '';  
elseif (nargin == 1)
    DBase = 'osm';
    username = 'postgres'; %username = '';
    password = 'postgres'; %password = '';          
end

% Set maximum time allowed for establishing a connection.
setdbprefs('DataReturnFormat','cellarray');
% Connect to the RSC database via JDBC
connA=database(DBase, username, password,...
               'org.postgresql.Driver', 'jdbc:postgresql://localhost/')

% Check the database status.
ping(connA)

% Open cursor and execute SQL statement.
% for some reason, 'select time from table' doesn't seem to work
        
disp(sqlquery);

cursorA=exec(connA, [sqlquery]);

disp(cursorA);

%% Fetch the first 10 rows of data.
%cursorA=fetch(cursorA, 10)
cursorA=fetch(cursorA)
 
% Display the data.
DataMat = cursorA.Data;

% Close the cursor and the connection.
close(cursorA);
close(connA);