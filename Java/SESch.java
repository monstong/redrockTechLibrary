// required SEOracle.java, SEMssql.java , JSCH jar

import java.io.*;
import com.jcraft.jsch.*;
import com.jcraft.Channel.*;


public class SESch {
    JSch jschcon;
    Session session;
    Channel channel;
    ChannelSftp chSftp;

    void sessionConnect(String host, String username, String passwd){
        jschcon = new JSch();

        try {
            session = jschcon.getSession(username, host, 22);
            session.setPassword(passwd);
            session.setConfig("StrictHostKeyChecking", "no");
            session.connect(5 * 1000); 
        }
        catch (JSchException je){
            System.out.println(je);
        }
    }

    void channelConnect(String connType){
        try {
            channel = session.openChannel(connType);
            channel.connect( 5* 1000);
        }
        catch (JSchException je){
            System.out.println(je);
        }
    }

    boolean checkConnection(String host, String username, String passwd){
        jschcon = new JSch();

        try {
            session = jschcon.getSession(username, host, 22);
            session.setPassword(passwd);
            session.setConfig("StrictHostKeyChecking", "no");
            session.connect(5 * 1000); 
        }
        catch (JSchException je){
            return false;
        }
        session.disconnect();
        return true;
    }

    void runScript(String CmdFilename, String OutputFilename){
        String tmpCmd, tmpStr;
        BufferedReader fbr, br;
        BufferedWriter fbw;
        File cmdFile = new File(CmdFilename);
        File outFile = new File(OutputFilename);
        DataInputStream dataIn;
        DataOutputStream dataOut;

        if(!cmdFile.exist()){
            System.out.println("There is no script file");
            System.exit(-1);      
        }

        try {
            dataIn = new DataInputStream(channel.getInputStream());
            dataOut = new DataOutputStream(channel.getOutputStream());

            fbr = new BufferedReader(new FileReader(cmdFile));

            while(fbr.ready()){
                tmpCmd = fbr.readLine();
                dataOut.writeBytes(tmpCmd + "\r\n");
                dataOut.flush();
            }

            dataOut.writeBytes("exit\r\n");
            dataOut.flush();

            br = new BufferedReader(new InputStreamReader(dataIn));
            fbw = new BufferedWriter(new FileWriter(outFile));

            while( (tmpStr = br.readLine()) != null){
                fbw.write(tmpStr);
                fbw.newLine();
            }
            dataIn.close();
            dataOut.close();
            fbr.close();
            br.close();
            fbw.close();
        }
        catch (IOException e){
            e.printStackTrace();
        }
    }

    void runScript(String CmdFilename){
        String tmpCmd, tmpStr;
        BufferedReader fbr, br;
        File file = new File(CmdFilename);
        DataInputStream dataIn;
        DataOutputStream dataOut;

        if(!file.exist()){
            System.out.println("There is no script file");
            System.exit(-1);      
        }

        try {
            dataIn = new DataInputStream(channel.getInputStream());
            dataOut = new DataOutputStream(channel.getOutputStream());

            fbr = new BufferedReader(new FileReader(file));

            while(fbr.ready()){
                tmpCmd = fbr.readLine();
                dataOut.writeBytes(tmpCmd + "\r\n");
                dataOut.flush();
            }

            dataOut.writeBytes("exit\r\n");
            dataOut.flush();

            br = new BufferedReader(new InputStreamReader(dataIn));

            while( (tmpStr = br.readLine()) != null){
                System.out.println(tmpStr);
            }
            dataIn.close();
            dataOut.close();
            fbr.close();
            br.close();
        }
        catch (IOException e){
            e.printStackTrace();
        }
    }

    void runCmd(String CmdFilename, String OutputFilename){
        String tmpCmd, tmpStr;
        BufferedReader fbr, br;
        BufferedWriter fbw;
        File cmdFile = new File(CmdFilename);
        File outFile = new File(OutputFilename);
        DataInputStream dataIn;
        DataOutputStream dataOut;

        if(!cmdFile.exist()){
            System.out.println("There is no script file");
            System.exit(-1);      
        }

        try {
            if(outFile.exists()){
                PrintWriter pw = new PrintWriter(new FileWriter(outFile));
                pw.print("");
                pw.close();

                outFile = new File(OutputFilename);
            }

            fbr = new BufferedReader(new FileReader(cmdFile));

            while(fbr.ready()){
                tmpCmd = fbr.readLine();
                channel = session.openChannel("exec");
                ((ChannelExec)channel).setPty(true);
                ((ChannelExec)channel).setCommand(tmpCmd);
                channel.connect(5 * 1000);

                dataIn = new DataInputStream(channel.getInputStream());

                br = new BufferedReader(new InputStreamReader(dataIn));
                fbw = new BufferedWriter(new FileWriter(outFile,true));

                while( (tmpStr = br.readLine()) != null){
                    fbw.write(tmpStr);
                    fbw.newLine();
                }
                br.close();
                fbw.close();
                dataIn.close();
                channel.disconnect();
            }
            fbr.close();
        }
        catch (IOException e){
            e.printStackTrace();
        }
        catch (JSchException je){
            je.printStackTrace();
        }
    }

    void runSingleCmd(String CmdFilename, String errFilename){
        DataInputStream dataIn;
        DataOutputStream dataOut;
        BufferedReader br;
        BufferedWriter bw;
        File errFile = new File(errFilename);

        try {
            dataOut = new DataOutputStream(channel.getOutputStream());
            dataIn = new DataInputStream(channel.getInputStream());

            dataOut.writeBytes(CmdFilename + "\r\n");
            dataOut.flush();
            dataOut.writeBytes("exit\r\n");
            dataOut.flush();

            br = new BufferedReader(new InputStreamReader(dataIn));
            bw = new BufferedWriter(new FileWriter(errFile));

            String tmpStr;
            while( (tmpStr = br.readLine()) != null){
                bw.write(tmpStr);
                bw.newLine();
            }
            dataIn.close();
            dataOut.close();
            br.close();
            bw.close();
        }
        catch (IOException ie){
            io.printStackTrace();
        }
    }

    boolean uploadFile(String uploadPath, String filename){
        try {
            chSftp = (ChannelSftp)channel;
            chSftp.mkdir(uploadPath);
        }
        catch (SftpException se){
            if(se.toString().equals("4: Failure")){
                System.out.println(uploadPath + "Directory already exists!");
            }
            else System.out.println(se.toString());
        }

        try {
            chSftp.cd(uploadPath);
        }
        catch (SftpException se){
            System.out.println(se.toString());
        }

        try {
            chSftp.rm(filename);
        }
        catch (SftpException se){
            if(se.toString().equals("2: No such file")){
                System.out.println(uploadPath + "/" + filename + " can not be found to remove.");
            }
            else System.out.println(se.toString());
        }

        try {
            chSftp.put(filename,".");
            chSftp.chmod(448,filename);
        }
        catch (SftpException se){
            System.out.println(se.toString());
        }
        
        System.out.println(uploadPath + "/" + filename + " is uploaded!");
        return true;

    }

    boolean downloadFile(String downloadPath, String filename){
        try {
            chSftp = (ChannelSft)channel;

            chSftp.cd(downloadPath);
            chSftp.get(filename,".");
        }
        catch (SftpException je){
            System.out.println(je);
        }
        System.out.println(downloadPath + filename + " is downloaded!");

        return true;
    }

    void allClose(){
        channel.disconnect();
        session.disconnect();
    }

    void channelClose(){
        channel.disconnect();
    }

    void sessionClose(){
        session.disconnect();
    }
}