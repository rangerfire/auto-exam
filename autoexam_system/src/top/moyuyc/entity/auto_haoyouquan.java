package chuang.wang;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.awt.List;



public class auto_haoyouquan {
	//����Ȧ����
	public static List getfriendtop(String username,int size,int index)
	{
		ResultSet rs = null;
		Statement stmt = null;
		Connection conn = null;
		List friends_name = new List();
		List result = new List();
		try{
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/auto_exam_system","root","123456");
			stmt = conn.createStatement();
			int friendsnumb = 0;
			//��֪һ���û���username�����������к���,����friends��
			String sql1 = "select * from friends where user1 = '"+username+"'";
			rs = stmt.executeQuery(sql1);
			while(rs.next())
			{	
				friends_name.add( rs.getString("user2"));
				friendsnumb++;
			}
			String sql2 = "select * from friends where user2 = '"+username+"'";
			rs = stmt.executeQuery(sql2);
			while(rs.next())
			{	
				friends_name.add( rs.getString("user1"));
				friendsnumb++;
			}
			int[] friends_point = new int[friendsnumb];
			int i = 0;
			while(i < friendsnumb)
			{
				String sql3 = "select * from user_point where user_name = '"+friends_name.getItem(i)+"'";
				rs = stmt.executeQuery(sql3);
				while(rs.next())
					friends_point[i] = rs.getInt("point");
				i++;
			}
			//�����Ѿ�֪�����������Ͷ�Ӧ���֣���Ҫ����������ص� size*(index-1)+1 �� size*index ����
			int temp;
			
			for(int k=friendsnumb-1;k>0;--k)
			{
				for(int j=0;j<k;++j)
				{
					if(friends_point[j+1] > friends_point[j])
					{
						temp = friends_point[j];
						friends_point[j] = friends_point[j+1];
						friends_point[j+1] = temp;
						//name��ҲҪ��λ��
						String s1 = friends_name.getItem(j);
						String s2 = friends_name.getItem(j+1);
 						friends_name.replaceItem(s2, j);
 						friends_name.replaceItem(s1, j+1);
					}
				}
			}
			
			for(int p=size*(index-1)+1;p<=size*index;p++)
				result.add( friends_name.getItem(p) );
			
		}
		catch(ClassNotFoundException e)
		{
			e.printStackTrace();
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				if(rs != null)
				{
					rs.close();
					rs = null;
				}
				if(stmt != null)
				{
					stmt.close();
					stmt = null;
				}
				if(conn != null)
				{
					conn.close();
					conn = null;
				}
			}
			catch(SQLException e)
			{
				e.printStackTrace();
			}
		}//endfinally
		System.out.println("����");
		return result;
	}
	
	//�����û�����
	public static List getuserstop(int size,int index)
	{
		ResultSet rs = null;
		Statement stmt = null;
		Connection conn = null;
		List result = new List();
		try{
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/auto_exam_system","root","123456");
			stmt = conn.createStatement();
			//���ص� size*(index-1)+1 �� size*index ��
			String sql = "select * from user_point order by point desc "; 	//��������
			rs = stmt.executeQuery(sql);
			int i = 0;
			while(rs.next())
			{
				i++;
				if(i>=size*(index-1)+1 && i<=size*index)
				{
					result.add(rs.getString("user_name"));
				}
			}
		}
		catch(ClassNotFoundException e)
		{
			e.printStackTrace();
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				if(rs != null)
				{
					rs.close();
					rs = null;
				}
				if(stmt != null)
				{
					stmt.close();
					stmt = null;
				}
				if(conn != null)
				{
					conn.close();
					conn = null;
				}
			}
			catch(SQLException e)
			{
				e.printStackTrace();
			}
		}//endfinally
		System.out.println("����");
		return result;
	}
	public static void main(String[] args) {
	
	}

}
