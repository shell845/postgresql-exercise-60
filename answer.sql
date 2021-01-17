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
                                                    
-- 21.查询在2月份入职的所有员工信息
select *
from emp
where extract('month' from hiredate) = 2;
 
-- 22.查询所有员工入职以来的工作期限，用“XX年XX月XX日”的形式表示
select empname, age(hiredate) from emp;

-- 23.查询至少有一个员工的部门信息
select dept.dname, dept.deptno, count(emp.deptno) 
from dept 
left join emp
on dept.deptno = emp.deptno
group by dept.deptno
having count(emp.deptno) >= 1;
/*
QUERY PLAN                                                     
--------------------------------------------------------------------------------------------------------------------
 HashAggregate  (cost=45.94..52.69 rows=540 width=66) (actual time=0.066..0.071 rows=3 loops=1)
   Group Key: dept.deptno
   Filter: (count(emp.deptno) >= 1)
   Rows Removed by Filter: 1
   ->  Hash Right Join  (cost=22.15..41.89 rows=540 width=66) (actual time=0.026..0.046 rows=14 loops=1)
         Hash Cond: (emp.deptno = dept.deptno)
         ->  Seq Scan on emp  (cost=0.00..14.10 rows=410 width=4) (actual time=0.002..0.004 rows=13 loops=1)
         ->  Hash  (cost=15.40..15.40 rows=540 width=62) (actual time=0.014..0.014 rows=4 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 1kB
               ->  Seq Scan on dept  (cost=0.00..15.40 rows=540 width=62) (actual time=0.006..0.009 rows=4 loops=1)
 Planning time: 0.218 ms
 Execution time: 0.154 ms
(12 rows)
*/

select * 
from emp 
where deptno in (select deptno 
                 from emp 
                 group by deptno 
                 having count(deptno) >= 1
);
/*
QUERY PLAN                                                        
-------------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=23.15..42.89 rows=205 width=168) (actual time=0.060..0.075 rows=13 loops=1)
   Hash Cond: (emp.deptno = emp_1.deptno)
   ->  Seq Scan on emp  (cost=0.00..14.10 rows=410 width=168) (actual time=0.007..0.009 rows=13 loops=1)
   ->  Hash  (cost=20.65..20.65 rows=200 width=4) (actual time=0.035..0.035 rows=3 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 1kB
         ->  HashAggregate  (cost=16.15..18.65 rows=200 width=4) (actual time=0.029..0.032 rows=3 loops=1)
               Group Key: emp_1.deptno
               Filter: (count(emp_1.deptno) >= 1)
               ->  Seq Scan on emp emp_1  (cost=0.00..14.10 rows=410 width=4) (actual time=0.003..0.007 rows=13 loops=1)
 Planning time: 0.251 ms
 Execution time: 0.158 ms
(11 rows)
*/

-- 24.查询至少有两个员工的部门信息
select dept.deptno, dept.dname, count(emp.deptno)
from dept
left join emp on dept.deptno = emp.deptno
group by dept.deptno
having count(emp.deptno) >= 2;


-- 25.查询工资比SMITH员工工资高的所有员工信息
select *
from emp
left join emp smith
on smith.empname = 'SMITH'
where emp.sal > smith.sal;

select * 
from emp
where sal > (select sal 
              from emp 
              where empname = 'SMITH') 
order by sal desc;

-- 26.查询所有员工的姓名及其直接上级的姓名
select emp.empname as employee, 
       manager.empname as manager
from emp
left join emp manager
on emp.mgp = manager.empno;

-- 27.查询入职日期早于其直接上级领导的所有员工信息
select emp.empname as employee, 
       emp.hiredate as emp_hiredate, 
       manager.empname as manager, 
       manager.hiredate as mgr_hiredate
from emp
left join emp manager
on emp.mgp = manager.empno 
where emp.hiredate < manager.hiredate;


-- 28.查询所有部门及其员工信息，包括那些没有员工的部门
select * from dept
left join emp
on dept.deptno = emp.deptno;

-- 29.查询所有员工及其部门信息，包括那些还不属于任何部门的员工
select * 
from emp 
left join dept 
on emp.deptno = dept.deptno;

-- 30.查询所有工种为CLERK的员工的姓名及其部门名称
select emp.empname, emp.job, dept.dname
from emp
left join dept
on emp.deptno = dept.deptno
where emp.job = 'CLERK';

-- 31.查询最低工资大于2500的各种工作
select distinct job from emp where sal > 2500;

-- 32.查询平均工资低于3000的部门及其员工信息
select emp.deptno, emp.empno, emp.empname, temp.avg_sal
from emp
inner join (select deptno, avg(sal) as avg_sal
      from emp
      group by deptno
      having avg(sal) < 3000) temp
on emp.deptno = temp.deptno;

select emp.deptno, emp.empno, emp.empname
from emp
where emp.deptno in (select deptno
                     from emp
                     group by deptno
                     having avg(sal) < 3000)
;

-- 33.查询在SALES部门工作的员工的姓名信息
select emp.empname, dept.dname
from emp
left join dept
on emp.deptno = dept.deptno
where dept.dname = 'SALES';

-- 34.查询工资高于公司平均工资的所有员工信息
select emp.empname, emp.sal, temp.avg_sal
from emp
left join (select avg(sal) as avg_sal from emp) temp
on true
where emp.sal > temp.avg_sal;

select emp.empname, emp.sal, temp.avg_sal
from emp
cross join (select avg(sal) as avg_sal from emp) temp
where emp.sal > temp.avg_sal;

/*
join on true is an unconditional JOIN

different from CROSS JOIN 
in that all rows from the left table expression are returned, 
even if there is no match in the right table expression
while a CROSS JOIN drops such rows from the result
*/

select emp.empname, emp.sal
from emp
where emp.sal > (select avg(sal) as avg_sal from emp);

-- 35.查询出与SMITH员工从事相同工作的所有员工信息
select emp.empno, 
       emp.empname, 
       emp.job, 
       emp.mgp, 
       emp.hiredate, 
       emp.sal, 
       emp.comm
from emp
left join emp s
on s.empname = 'SMITH'
where emp.job = s.job;

-- 36.列出工资等于30部门中某个员工的工资的所有非30部门员工的姓名和工资
select empname, sal, deptno
from emp 
where sal in (select sal from emp where deptno = 30)
and deptno <> 30;

-- 37.查询工资高于30部门工作的所有员工的工资的员工姓名和工资
select *
from emp
left join (select sal
           from emp
           where deptno = 30
           order by sal desc
           limit 1) max_sal
on true
where emp.sal > max_sal.sal;

select *
from emp
where sal > (select sal
           from emp
           where deptno = 30
           order by sal desc
           limit 1)
and deptno <> 30
;

-- 38.查询每个部门中的员工数量、平均工资和平均工作年限
select deptno, count(*), coalesce(avg(sal), 0), coalesce(avg(age(hiredate)))
from emp
group by deptno;

-- 39.查询从事同一种工作但不属于同一部门的员工信息
select *
from emp e1
where e1.job in (select e2.job from emp e2 where e1.deptno <> e2.deptno);

-- 40.查询各个部门的详细信息以及部门人数、部门平均工资
select dept.deptno, dept.dname, count(emp.empno), coalesce(avg(sal),0), avg(age(hiredate))
from dept
left join emp
on dept.deptno = emp.deptno
group by dept.deptno, dept.dname;

select dept.deptno, 
       dept.dname, 
       t.c as count, 
       t.s as avg_sal, 
       t.d as avg_period
from dept
left join (select deptno, 
                  count(*) as c, 
                  avg(sal) as s, 
                  avg(age(hiredate)) as d
           from emp
           group by deptno) t
on dept.deptno = t.deptno
;
