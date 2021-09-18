// required SEMssql.java, SEOracle.java, SESch.java, jsch.jar  ojdbc.jar mssql jdbc.jar

import java.io.*;
import java.util.*;
import java.text.*;
import java.net.*;

public class AGGUAgent20 {
    private static String connInfoDocName = null;
    private static String connInfoDocVersion = null;
    private static String connInfoEncryptionKey = null;

    private static String connInfoPathName = null;
    private static String scriptPathName = null;

    private static String tmpScriptname = null;
    private static String wTmpScriptname = null;

    private static SESch sesch = new SESch();
    private static SEMssql semssql = new SEMssql();
    private static SEOracle seo = new SEOracle();
    
    private static String today = new SimpleDateFormat("yyyymmdd").Format(Calendar.getInstance().getTime());

    //for upload agent
    private static DevConnInfo upDevcf = new DevConnInfo();

    // main conn info
    private static void Vector<DevConnInfo> vConnInfoList = new Vector();

    private static void printMenuHeader(){
        System.out.println("\tAGGU Agent 2.0");
        System.out.println("No\tHOSTNAME\tIP ADDRESS\tMODELTYPE\tConnection");
        System.out.println("-----\t-----\t-----\t-----\t-----");
    }

    private static Stirng selectMenu(){

    }

    private static class DevConnInfo {
        private String hostname;
        private String ipAddr;
        private String modelType;
        private String userId;
        private String passwd;
        private String connStatus;
        private boolean selected = false;

        public void setInfo(String phost, String pip, String pmodel, String puser, String ppass){
            hostname = phost;
            ipAddr = pip;
            modelType = pmodel;
            userId = puser;
            passwd = ppass;
        }

        public String getHostname(){
            return hostname;
        }

        public String getIpAddr(){
            return ipAddr;
        }

        public String getModelType(){
            return modelType;
        }

        public String getUserId(){
            return userId;
        }

        public String getPasswd(){
            return passwd;
        }
        
        public String getConnStatus(){
            return connStatus;
        }

        public void setConnStatus(Stirng pStatus){
            connStatus = pStatus;
        }

        public boolean getSelected(){
            return selected;
        }

        public void setSelected(boolean pSelect){
            selected = pSelect;
        }

    }
}