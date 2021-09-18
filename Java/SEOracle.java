// required jdbc.jar

import java.sql.*;
import java.io.*;


public class SEOracle {

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    ResultSetMetaData rsmd = null;
    String DriverName = "oracle.jdbc.driver.OracleDriver";

    void DBConnect(STring host, String port, String DBName, String userId, String passwd){
        String connURL;
        connURL = "jdbc:oracle:thin:@" + host + ":" + port + ":" + DBName;

        try {
            Class.forName(DriverName);
            con = DriverManager.getConnection(connURL,userId,passwd);
        }
        catch (Exception e){
            System.out.println(e);
        }
    }

    boolean checkConnection(String host, String port, String DBName, String userId, String passwd){
        String connURL;
        connURL = "jdbc:oracle:thin:@" + host + ":" + port + ":" + DBName;

        try {
            Class.forName(DriverName);
            con = DriverManager.getConnection(connURL,userId,passwd);
            con.close();
        }
        catch (Exception e){
            return false;
        } 
        return true;       
    }

    void execDML(String sqlstmt){
        try {
            pstmt = con.prepareStatement(sqlstmt);
            pstmt.executeUpdate();
        }
        catch (Exception e){
            System.out.println(e + "SQL : " + sqlstmt);
        }
    }

    void execSQL(String sqlstmt){
        int rsColCount;

        try {
            pstmt = con.prepareStatement(sqlstmt);
            rs = pstmt.executeQuery();
            rsmd = rs.getMetaData();
            rsColCount = rsmd.getColumnCount();

            System.out.println(rsColCount);
            while (rs.next()){
                for (int i = 1;i <= rsColCount;i++){
                    System.out.print(rs.getString(i) + " " );
                }
                System.out.println();
            }
        }
        catch (Exception e){
            System.out.println(e + "SQL : " + sqlstmt);
        }
    }

    void execSQL(String sqlFile,String filename){
        int rsColCount;
        String tmpSql;
        tmpSql = null;

        try {
            File outFile = new File(filename);
            if(outFile.exists()){
                PrintWriter pw = new PrintWriter(new FileWriter(outFile));
                pw.print("");
                pw.close();
            }
            BufferedWriter fbw = new BufferedWriter(new FileWriter(outFile));
            BufferedReader fbr = new BufferedReader(new FileReader(sqlFile));

            while(fbr.ready()){
                try {
                    tmpSql = fbr.readLine();
                    pstmt = con.prepareStatement(tmpSql);
                    rs = pstmt.executeQuery();
                    rsmd = rs.getMetaData();
                    rsColCount = rsmd.getColumnCount();

                    while (rs.next()){
                        for (int i = 1;i <= rsColCount;i++){
                            fbw.write(rs.getString(i) + " " );
                        }
                        fbw.newLine();
                    }
                }
                catch (SQLException se){
                    System.out.println(se + "SQL : " + tmpSql);
                }
            }
            fbw.close();
        }
        catch (Exception e){
            System.out.println(e);
        }
    }
    
    String execSingleSQL(String sqlstmt){
        String resultValue = "";

        try {
            pstmt = con.prepareStatement(sqlstmt);
            rs = pstmt.executeQuery();

            while(rs.next()){
                resultValue = rs.getString(1);
            }
        }
        catch (Exception e){
            System.out.println(e + "SQL : " + sqlstmt);
        }

        return resultValue;
    }

    void AllClose(){
        try {
            rs.close();
            pstmt.close();
            con.close();
        }
        catch (Exception e){
            System.out.println(e);
        }
    }

}