package project.spring.hohotest.controller.admin.order;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import project.spring.hohotest.helper.PageHelper;
import project.spring.hohotest.helper.WebHelper;
import project.spring.hohotest.model.Member;
import project.spring.hohotest.model.Orders;
import project.spring.hohotest.service.MemberService;
import project.spring.hohotest.service.OrderService;

@Controller
public class AdminOrderListController {
	/** Helper 객체 선언 */
	@Autowired
	WebHelper web;
	@Autowired
	OrderService orderService;
	@Autowired
	MemberService memberService;
	@Autowired
	PageHelper pageHelper;
	
	@RequestMapping(value = "/admin/order/adminOrderList.do")
	public ModelAndView doRun(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		
		web.init();
		
		int page = web.getInt("page", 1);
		int totalCount = 0;
		int maxPageNo = 0;
		List<Orders> orderList = null;
		List<Member> memberList = new ArrayList<Member>();
		Orders order = new Orders();
		Member member = new Member();
		
		try {
			// 페이징 작업
			totalCount = orderService.selectOrderCount(order);
			pageHelper.pageProcess(page, totalCount, 12, 5);

			order.setLimitStart(pageHelper.getLimitStart());
			order.setListCount(pageHelper.getListCount());
			
			// 주문 목록 가져오기
			orderList = orderService.selectOrderList(order);
			memberList = memberService.selectAllMember(member);
			
			// member에서 user_id를 가져오기 위한 for문
			for( Orders o : orderList ) {
				member.setId(o.getMember_id());
				
				Member m = new Member();
				m = memberService.selectMember(member);
				
				memberList.add(m);
			}
			
		} catch (Exception e) {
			return web.redirect(null, e.getLocalizedMessage());
		}
		
		maxPageNo = pageHelper.getTotalCount() - (pageHelper.getPage() - 1)	* pageHelper.getListCount();

		model.addAttribute("orderList", orderList);
		model.addAttribute("memberList", memberList);
		model.addAttribute("pageHelper", pageHelper);
		model.addAttribute("maxPageNo", maxPageNo);
		
		return new ModelAndView("admin/order/adminOrderList");
	}
}
