-- ======================
-- Задача 1
-- ======================
WITH RECURSIVE subordinates AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    WHERE e.EmployeeID = 1

    UNION ALL

    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    JOIN subordinates s ON e.ManagerID = s.EmployeeID
)
SELECT
    s.EmployeeID,
    s.Name AS EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (
        SELECT GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')
        FROM Projects p
        WHERE p.DepartmentID = s.DepartmentID
    ) AS ProjectNames,
    (
        SELECT GROUP_CONCAT(t.TaskName ORDER BY t.TaskName SEPARATOR ', ')
        FROM Tasks t
        WHERE t.AssignedTo = s.EmployeeID
    ) AS TaskNames
FROM subordinates s
LEFT JOIN Departments d ON d.DepartmentID = s.DepartmentID
LEFT JOIN Roles r ON r.RoleID = s.RoleID
ORDER BY s.Name;

-- ======================
-- Задача 2
-- ======================
WITH RECURSIVE subordinates AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    WHERE e.EmployeeID = 1

    UNION ALL

    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    JOIN subordinates s ON e.ManagerID = s.EmployeeID
)
SELECT
    s.EmployeeID,
    s.Name AS EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (
        SELECT GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')
        FROM Projects p
        WHERE p.DepartmentID = s.DepartmentID
    ) AS ProjectNames,
    (
        SELECT GROUP_CONCAT(t.TaskName ORDER BY t.TaskName SEPARATOR ', ')
        FROM Tasks t
        WHERE t.AssignedTo = s.EmployeeID
    ) AS TaskNames,
    (
        SELECT COUNT(*)
        FROM Tasks t
        WHERE t.AssignedTo = s.EmployeeID
    ) AS TotalTasks,
    (
        SELECT COUNT(*)
        FROM Employees e2
        WHERE e2.ManagerID = s.EmployeeID
    ) AS TotalSubordinates
FROM subordinates s
LEFT JOIN Departments d ON d.DepartmentID = s.DepartmentID
LEFT JOIN Roles r ON r.RoleID = s.RoleID
ORDER BY s.Name;

-- ======================
-- Задача 3
-- ======================
WITH RECURSIVE manager_tree AS (
    SELECT
        e.EmployeeID AS ManagerEmployeeID,
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e

    UNION ALL

    SELECT
        mt.ManagerEmployeeID,
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    JOIN manager_tree mt ON e.ManagerID = mt.EmployeeID
),
subordinate_counts AS (
    SELECT
        ManagerEmployeeID,
        COUNT(*) - 1 AS TotalSubordinates
    FROM manager_tree
    GROUP BY ManagerEmployeeID
)
SELECT
    e.EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (
        SELECT GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')
        FROM Projects p
        WHERE p.DepartmentID = e.DepartmentID
    ) AS ProjectNames,
    (
        SELECT GROUP_CONCAT(t.TaskName ORDER BY t.TaskName SEPARATOR ', ')
        FROM Tasks t
        WHERE t.AssignedTo = e.EmployeeID
    ) AS TaskNames,
    sc.TotalSubordinates
FROM Employees e
JOIN Roles r ON r.RoleID = e.RoleID
LEFT JOIN Departments d ON d.DepartmentID = e.DepartmentID
JOIN subordinate_counts sc ON sc.ManagerEmployeeID = e.EmployeeID
WHERE r.RoleName = 'Менеджер'
  AND sc.TotalSubordinates > 0
ORDER BY e.Name;
