package com.i2i.evrencell;

import com.i2i.evrencell.voltdb.VoltCustomer;
import com.i2i.evrencell.voltdb.VoltPackage;
import com.i2i.evrencell.voltdb.VoltdbOperator;
import org.voltdb.client.ProcCallException;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;

public class Main {
    public static void main(String[] args) throws IOException, InterruptedException, ProcCallException {

        double startTime = System.currentTimeMillis();
        VoltdbOperator voltdbOperator = new VoltdbOperator();

        //voltdbOperator.updatePassword("buBenimYepyeniParolam", "john.doe@example.com","12345678901");
        //System.out.println(voltdbOperator.getCustomerIdByEmailAndTc("john.doe@example.com","12345678901"));

        //System.out.println(voltdbOperator.checkCustomerExists("john.doe@example.com","12345678901"));

        voltdbOperator.updateDataBalance(1200,"5537030253");
        /*voltdbOperator.updateVoiceBalance(620,"5537030253");
        voltdbOperator.updateSmsBalance(280,"5537030253");
*/
        /*voltdbOperator.insertCustomer(87,"son1","son1","son1","son1","son",new Timestamp(System.currentTimeMillis()),"son1");
        voltdbOperator.insertBalance(73,87,3,999,999,999,new Timestamp(System.currentTimeMillis()),new Timestamp(System.currentTimeMillis()));
        System.out.println(voltdbOperator.getPackageInfoByPackageId(2));*/

        double endTime = System.currentTimeMillis();
        double elapsedTime = endTime - startTime;
        System.out.println("Elapsed time: " + elapsedTime);
    }
}