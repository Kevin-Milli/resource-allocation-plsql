# Resource Allocation Project

## Utilities
For this project, a log table and a package `PKG_UTILS` have been used to facilitate the logging of data into the log table. The package is defined as follows:

```sql
create or replace package pkg_utils is
    procedure plog(p_caller varchar2, p_orcl_code varchar2, p_orcl_msg varchar2);
end;

create or replace package body pkg_utils is 
    procedure plog(p_caller varchar2, p_orcl_code varchar2, p_orcl_msg varchar2) is
            time_stmp date := sysdate;
        begin 
            insert into tlog_error(
                caller,
                orcl_code,
                ORCL_MSG,
                time_stamp
            )
            values(
                p_caller,
                p_orcl_code,
                p_orcl_msg,
                time_stmp
            );
            commit;
        end;
end;
```
## Project Description
### 1. "ALLOCATE" Procedure Objective:
The "ALLOCATE" project is a PL/SQL procedure designed to manage the allocation of human resources to specific projects within a business management system. 
The procedure verifies and assigns personnel to projects based on required and available skills, ensuring that each project has the necessary number of resources with the required qualifications.

### Procedure Structure:

1. **Variable and Cursor Declarations:**

**Variables:**
- `TODAY_DATE`: A test project start date.
- `TOT_SKILLS`: Number of skills an employee possesses.
- `NR_SKILLS_REQUIRED`: Number of skills required by the project.
- `V_FOUND`: Flag to check if an employee is found.
- `IS_ALREADY_A_PRJ`: Counter to verify if the project already exists.
- `V_COUNT`: Counter for project existence check.

**Cursors:**
- `C_EMP`: Selects employees based on the number of skills possessed and hire date, ordered by descending skills and ascending hire date.
- `C_EMP_SKL`: Selects employees and their skills for the specific project.

2. **Project Existence Check:**
- The procedure checks if the project passed as a parameter (`P_COD_PRJ`) exists in the project table (`T_PRJ`). If the project does not exist, an error is raised.

3. **Managing Existing Projects:**
- If the project already exists, the procedure verifies if employees are already allocated. If so:
- It checks if the number of skills of allocated employees matches the required skills.
- If the number of skills is sufficient, the procedure ends without changes.
- If insufficient, it searches for additional employees with missing skills and adds them to the project.

4. **Managing New Projects:**
- For new projects, the procedure selects the most suitable employee based on the number of skills and hire date.
- If the selected employee has the required number of skills, they are allocated to the project.
- If the employee lacks some skills, another employee with the missing skills is found and allocated to the project.

5. **Error Handling:**
- Each step of the procedure is protected by error-handling blocks to ensure that any errors are logged and handled properly.

---

### 2. "DEALLOCATE" Procedure Objective:
The "DEALLOCATE" procedure is designed to manage the removal of an existing project from the system and ensure that employees previously allocated to that project do not have gaps in their availability. 
The procedure updates employee allocations and removes the project assignments to be deleted.

### Procedure Structure:
1. **Variable and Cursor Declarations:**

**Variables:**
- `V_PROJECT_END_DATE`: The end date of the project to be deleted.
- `V_PROJECT_DURATION`: The duration of the project to be deleted, calculated in days.
- `V_COUNT`: Counter for project existence check.

**Cursors:**
- `C_EMP_PROJ`: Selects employees and their allocation start and end dates for the project to be deleted.

2. **Project Existence Check:**
- The procedure checks if the specified project (`P_COD_PRJ`) exists in the project table (`T_PRJ`). If the project does not exist, an error is raised.

3. **Retrieving Project Information:**
- Retrieves the project’s duration and end date to calculate how much to adjust the scheduling of other projects involving affected employees.

4. **Deleting Project Allocations:**
- Deletes all allocations associated with the project to be removed from the `T_ALLOC` table.

5. **Updating Employee Allocations:**
- Updates the start and end dates of employees' other allocations to avoid gaps in availability. Dates are adjusted based on the duration of the project to be deleted.

6. **Error Handling:**
- Error handling blocks are included to ensure proper logging and management of issues.


