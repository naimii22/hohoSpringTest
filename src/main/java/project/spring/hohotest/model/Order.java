package project.spring.hohotest.model;

public class Order {
	private int id;
	private int member_id;
	private String reg_date;
	private int total;
	private int status;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getMember_id() {
		return member_id;
	}
	public void setMember_id(int member_id) {
		this.member_id = member_id;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	
	@Override
	public String toString() {
		return "Order [id=" + id + ", member_id=" + member_id + ", reg_date=" + reg_date + ", total=" + total
				+ ", status=" + status + "]";
	}
}
