-- 2) Stored Procedure: UpdateSalaryByID
DELIMITER //
CREATE PROCEDURE UpdateSalaryByID(
    IN EmployeeIDInput INT,
    INOUT SalaryInput DECIMAL(10,2)
)
BEGIN
    IF SalaryInput < 20000000 THEN
        SET SalaryInput = SalaryInput * 1.10;
    ELSE
        SET SalaryInput = SalaryInput * 1.05;
    END IF;
    
    UPDATE Employees
    SET Salary = SalaryInput
    WHERE EmployeeID = EmployeeIDInput;
END //
DELIMITER ;

-- 3) Stored Procedure: GetLoanAmountByCustomerID
DELIMITER //
CREATE PROCEDURE GetLoanAmountByCustomerID(
    IN inputCustomerID INT,
    OUT TotalLoanAmount DECIMAL(15,2)
)
BEGIN
    SELECT COALESCE(SUM(LoanAmount), 0) INTO TotalLoanAmount
    FROM Loans
    WHERE CustomerID = inputCustomerID;
END //
DELIMITER ;

-- 4) Stored Procedure: DeleteAccountIfLowBalance
DELIMITER //
CREATE PROCEDURE DeleteAccountIfLowBalance(
    IN inputAccountID INT
)
BEGIN
    DECLARE balance_new DECIMAL(15,2);
    
    SELECT Balance INTO balance_new FROM Accounts WHERE AccountID = inputAccountID;
    
    IF balance_new < 1000000 THEN
        DELETE FROM Accounts WHERE AccountID = inputAccountID;
        SELECT 'Đã xóa tài khoản thành công' AS Message;
    ELSE
        SELECT 'Không thể xóa tài khoản' AS Message;
    END IF;
END //
DELIMITER ;

-- 5) Stored Procedure: TransferMoney
DELIMITER //
CREATE PROCEDURE TransferMoney(
    IN senderAccountID INT,
    IN receiverAccountID INT,
    INOUT transferAmount DECIMAL(15,2)
)
BEGIN
    DECLARE senderBalance DECIMAL(15,2);
    
    SELECT Balance INTO senderBalance FROM Accounts WHERE AccountID = senderAccountID;
    
    IF senderBalance >= transferAmount THEN
        UPDATE Accounts SET Balance = Balance - transferAmount WHERE AccountID = senderAccountID;
        UPDATE Accounts SET Balance = Balance + transferAmount WHERE AccountID = receiverAccountID;
    ELSE
        SET transferAmount = 0;
    END IF;
END //
DELIMITER ;

-- 6) Gọi Stored Procedures

-- Cập nhật lương của nhân viên ID = 4 từ 18 triệu
SET @Salary = 18000000;
CALL UpdateSalaryByID(4, @Salary);
SELECT @Salary AS NewSalary;

-- Lấy tổng số tiền vay của khách hàng ID = 1
SET @TotalLoan = 0;
CALL GetLoanAmountByCustomerID(1, @TotalLoan);
SELECT @TotalLoan AS LoanAmount;

-- Xóa tài khoản có ID = 8 nếu số dư nhỏ hơn 1 triệu
CALL DeleteAccountIfLowBalance(8);

-- Chuyển 2 triệu từ tài khoản ID = 1 sang ID = 3
SET @AmountToTransfer = 1500000;
CALL TransferMoney(1, 3, @AmountToTransfer);
SELECT @AmountToTransfer AS TransferredAmount;

-- 7) Xóa các thủ tục đã tạo
DROP PROCEDURE IF EXISTS UpdateSalaryByID;
DROP PROCEDURE IF EXISTS GetLoanAmountByCustomerID;
DROP PROCEDURE IF EXISTS DeleteAccountIfLowBalance;
DROP PROCEDURE IF EXISTS TransferMoney;
