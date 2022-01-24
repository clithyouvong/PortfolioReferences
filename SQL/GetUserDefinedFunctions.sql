select schema_name(obj.schema_id) as schema_name,
       obj.name as function_name,
       case type
            when 'FN' then 'SQL scalar function'
            when 'TF' then 'SQL inline table-valued function'
            when 'IF' then 'SQL table-valued-function'
        end as type,
        substring(par.parameters, 0, len(par.parameters)) as parameters,
        TYPE_NAME(ret.user_type_id) as return_type,
        mod.definition
from sys.objects obj
join sys.sql_modules mod
     on mod.object_id = obj.object_id
cross apply (select p.name + ' ' + TYPE_NAME(p.user_type_id) + ', ' 
             from sys.parameters p
             where p.object_id = obj.object_id 
                   and p.parameter_id != 0 
            for xml path ('') ) par (parameters)
left join sys.parameters ret
          on obj.object_id = ret.object_id
          and ret.parameter_id = 0
where obj.type in ('FN', 'TF', 'IF')
order by schema_name,
         function_name;
