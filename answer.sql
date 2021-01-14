--10.查询各月倒数第3天(倒数第2天)内入职的员工信息
select * 
from emp 
where hiredate::date = (date_trunc('month', hiredate::date) + interval '1 month' - interval '3 day')::date;

select *
from emp
where to_number(to_char(hiredate + '3 day', 'DD'), '99') < 2

-- 11.查询工龄大于或等于25年的员工信息
select * from emp where date_part('year', age(hiredate::date)) >= 25;

select * from emp where extract('year' from age(hiredate)) >= 25;   

-- 12.查询员工信息，要求以首字母大写的方式显示所有员工的姓名
select initcap(empname) from emp;       

-- 13.查询员工名正好为6个字符的员工的信息
select empname from emp where char_length(empname) = 6; 

-- 14.查询员工名字中不包含字母“Ｓ”的员工
select empname from emp where position('s' in lower(empname)) = 0; 

select empname from emp where lower(empname) not like '%s%';

-- 15.查询员工姓名的第二字母为“M”的员工信息
select empname from emp where position('m' in lower(empname)) = 2;  

select empname from emp where lower(empname) like '_m%';

-- 16.查询所有员工姓名的前三个字符
select left(empname, 3) from emp;   

-- 17.查询所有员工的姓名，如果包含字母“S”，则用“s”替换
select regexp_replace(empname, 'S', 's') from emp;

-- 18.查询员工的姓名和入职日期，并按入职日期从先到后进行排序
select empname, hiredate from emp order by hiredate;   

-- 19.显示所有员工的姓名、工种、工资和奖金，按工种降序排序，若工种相同则按工资升序排序
select empname, job, sal, comm from emp order by job desc, sal;    

-- 20.显示所有员工的姓名、入职的年份和月份，按入职日期所在的月份排序，若月份相同则按入职的年份排序
select empname, 
       extract('year' from hiredate) as hire_year, 
       extract('month' from hiredate) as hire_month from emp
order by extract('month' from hiredate), extract('year' from hiredate);
