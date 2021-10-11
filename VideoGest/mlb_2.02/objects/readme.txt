1- mlb2.pas
this file contains the basic MyLittleBase Object (TMlb2) that inherits from TObject,
from which all custom modules will inherit.

use mlb := TMlb2.Create to allocate a new mlb instance, 
and don't forget to free the object at the end by using mlb.Free

2- mlb2sql.pas
this file contains the experimental mono-table little SQL engine.
it needs the basic object's file (mlb2.pas), to be either in the lib directory of delphi, 
or in the same directory as mlb2sql.pas

use sql := TMlb2Sql.Create(mlb) to allocate a new sql instance working on the table mlb of type Mlb2,
use something like sql.Execute('SELECT DISTINCT WHERE field='AAA') to query the table mlb.
Result tables can be accessed by sql.GetDynaSet which is a TMlb2 object (a new table) for the query result,
and the sql.GetComplement which is a TMlb2 object too (a new table).
At the end free with sql.Free.

To sum up mlb contains the table to query, 
sql.Execute executes the query,
sql.GetDynaset points to a new table containing the query's result,
and sql.GetComplement points to a new table containing mlb's rows minus GetDynaset's rows.
