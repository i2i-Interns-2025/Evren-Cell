package com.i2i.aom.repository;

import com.i2i.aom.dto.CustomerBalance;
import com.i2i.aom.helper.OracleConnection;
import com.i2i.aom.helper.VoltDBConnection;
import com.i2i.aom.request.CreateBalanceRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.voltdb.VoltTable;
import org.voltdb.client.Client;
import org.voltdb.client.ClientResponse;
import org.voltdb.client.ProcCallException;

import java.io.IOException;
import java.sql.*;

@Repository
public class BalanceRepository {
    private final OracleConnection oracleConnection;
    private final VoltDBConnection voltDBConnection;

    public BalanceRepository(OracleConnection oracleConnection,
                             VoltDBConnection voltDBConnection) {
        this.oracleConnection = oracleConnection;
        this.voltDBConnection = voltDBConnection;
    }

    //oracle
//    public ResponseEntity createOracleBalance(CreateBalanceRequest createBalanceRequest) throws ClassNotFoundException, SQLException {
//        Connection conn = oracleConnection.getOracleConnection();
//
//        // Retrieve package details
//        PreparedStatement packageStatement = conn.prepareStatement(OracleQueries.SELECT_PACKAGE_DETAILS_ID);
//        packageStatement.setLong(1, createBalanceRequest.packageId());
//        ResultSet packageResultSet = packageStatement.executeQuery();
//
//        if (!packageResultSet.next()) {
//            packageStatement.close();
//            conn.close();
//            return new ResponseEntity<>("Package not found", HttpStatus.NOT_FOUND);
//        }
//
//        int amountMinutes = packageResultSet.getInt("AMOUNT_MINUTES");
//        int amountSms = packageResultSet.getInt("AMOUNT_SMS");
//        int amountData = packageResultSet.getInt("AMOUNT_DATA");
//        int period = packageResultSet.getInt("PERIOD");
//
//        packageStatement.close();
//
//        Timestamp sdate = new Timestamp(System.currentTimeMillis());
//        Timestamp edate = new Timestamp(sdate.getTime() + period * 24L * 60L * 60L * 1000L);
//
//        PreparedStatement balanceStmt = conn.prepareStatement(OracleQueries.INSERT_BALANCE_TO_CUSTOMER);
//        balanceStmt.setInt(1, createBalanceRequest.customerId());
//        balanceStmt.setInt(2, createBalanceRequest.packageId());
//        balanceStmt.setInt(3, amountMinutes);
//        balanceStmt.setInt(4, amountSms);
//        balanceStmt.setInt(5, amountData);
//        balanceStmt.setTimestamp(6, sdate);
//        balanceStmt.setTimestamp(7, edate);
//
//        balanceStmt.executeUpdate();
//        balanceStmt.close();
//        conn.close();
//
//        return new ResponseEntity<>("Balance created successfully", HttpStatus.CREATED);
//    }

    public ResponseEntity createOracleBalance(CreateBalanceRequest createBalanceRequest) throws ClassNotFoundException, SQLException {
        Connection conn = oracleConnection.getOracleConnection();

        CallableStatement packageStmt = conn.prepareCall("{call SELECT_PACKAGE_DETAILS_ID(?, ?, ?, ?, ?)}");
        packageStmt.setInt(1, createBalanceRequest.packageId());
        packageStmt.registerOutParameter(2, Types.INTEGER);
        packageStmt.registerOutParameter(3, Types.INTEGER);
        packageStmt.registerOutParameter(4, Types.INTEGER);
        packageStmt.registerOutParameter(5, Types.INTEGER);
        packageStmt.execute();
//        System.out.println("select success");

        int amountMinutes = packageStmt.getInt(2);
        int amountSms = packageStmt.getInt(3);
        int amountData = packageStmt.getInt(4);
        int period = packageStmt.getInt(5);
        packageStmt.close();

        if (amountMinutes == 0 && amountSms == 0 && amountData == 0 && period == 0) {
            conn.close();
            return new ResponseEntity<>("Package not found", HttpStatus.NOT_FOUND);
        }

        Timestamp sdate = new Timestamp(System.currentTimeMillis());
        Timestamp edate = new Timestamp(sdate.getTime() + period * 24L * 60L * 60L * 1000L);

        CallableStatement balanceStmt = conn.prepareCall("{call INSERT_BALANCE_TO_CUSTOMER(?, ?, ?, ?, ?, ?, ?)}");
        balanceStmt.setInt(1, createBalanceRequest.customerId());
        balanceStmt.setInt(2, createBalanceRequest.packageId());
        balanceStmt.setInt(3, amountMinutes);
        balanceStmt.setInt(4, amountSms);
        balanceStmt.setInt(5, amountData);
        balanceStmt.setTimestamp(6, sdate);
        balanceStmt.setTimestamp(7, edate);
        balanceStmt.execute();
//        System.out.println("balance success");

        balanceStmt.close();

        conn.close();

        return new ResponseEntity<>("Balance created successfully", HttpStatus.CREATED);
    }


    //voltdb
    public ResponseEntity createVoltBalance(CreateBalanceRequest createBalanceRequest) throws IOException, ProcCallException {
        Client client = voltDBConnection.getClient();


//        ClientResponse packageResponse = client.callProcedure("GetPackageById", createBalanceRequest.packageId());
        ClientResponse packageResponse = client.callProcedure("GET_PACKAGE_INFO_BY_PACKAGE_ID", createBalanceRequest.packageId());
        System.out.println(packageResponse.getResults()[0]);
        VoltTable packageTable = packageResponse.getResults()[0];

        if (!packageTable.advanceRow()) {
            return new ResponseEntity<>("Package not found in voltDb", HttpStatus.NOT_FOUND);
        }

        int amountMinutes = (int) packageTable.getLong("AMOUNT_MINUTES");
        int amountSms = (int) packageTable.getLong("AMOUNT_SMS");
        int amountData = (int) packageTable.getLong("AMOUNT_DATA");
        int period = (int) packageTable.getLong("PERIOD");

        Timestamp sdate = new Timestamp(System.currentTimeMillis());
        Timestamp edate = new Timestamp(sdate.getTime() + period * 24L * 60L * 60L * 1000L);

//        ClientResponse maxIdResponse = client.callProcedure("GetMaxBalanceId");
        ClientResponse maxIdResponse = client.callProcedure("GET_MAX_BALANCE_ID");
        VoltTable maxIdTable = maxIdResponse.getResults()[0];
        int maxBalanceId = 0;
        if (maxIdTable.advanceRow()) {
            maxBalanceId = (int) maxIdTable.getLong("MAX_BALANCE_ID");
        }
        int balanceId = maxBalanceId + 1;

//        client.callProcedure("InsertBalanceToCustomer",
        client.callProcedure("INSERT_BALANCE_TO_CUSTOMER",
                balanceId,
                createBalanceRequest.customerId(),
                createBalanceRequest.packageId(),
                amountMinutes,
                amountSms,
                amountData,
                sdate,
                edate
        );

        return new ResponseEntity<>("Balance created successfully", HttpStatus.CREATED);
    }

    public CustomerBalance getRemainingCustomerBalanceByMsisdn(String msisdn) throws IOException, ProcCallException, InterruptedException {
        Client client = voltDBConnection.getClient();
        ClientResponse response = client.callProcedure("GET_REMAINING_CUSTOMER_BALANCE_BY_MSISDN", msisdn);

        if (response.getStatus() == ClientResponse.SUCCESS) {
            VoltTable resultTable = response.getResults()[0];
            if (resultTable.advanceRow()) {
                String msisdnResult = resultTable.getString("MSISDN");
                int balanceData = (int) resultTable.getLong("BAL_LVL_DATA");
                int balanceSms = (int) resultTable.getLong("BAL_LVL_SMS");
                int balanceMinutes = (int) resultTable.getLong("BAL_LVL_MINUTES");
                Timestamp sdate = resultTable.getTimestampAsSqlTimestamp("SDATE");
                Timestamp edate = resultTable.getTimestampAsSqlTimestamp("EDATE");

                CustomerBalance balanceResponse = CustomerBalance.builder()
                        .msisdn(msisdnResult)
                        .balanceData(balanceData)
                        .balanceMinutes(balanceMinutes)
                        .balanceSms(balanceSms)
                        .sdate(sdate)
                        .edate(edate)
                        .build();

                client.close();
                return balanceResponse;
            }
        }
        client.close();
        return null;
    }
}
