package project.spring.hohotest.controller.cart;

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

import project.spring.hohotest.helper.WebHelper;
import project.spring.hohotest.model.Cart;
import project.spring.hohotest.model.Product;
import project.spring.hohotest.service.CartService;
import project.spring.hohotest.service.ProductService;

@Controller
public class MemberCartListController {
	@Autowired
	WebHelper web;
	@Autowired
	CartService cartService;
	@Autowired
	ProductService productService;
	
	@RequestMapping(value = "/user/cart/memberCartList.do")
	public ModelAndView doRun(Locale locale, Model model, HttpServletRequest request, HttpServletResponse response) {
		web.init();
		
		System.out.println("<<<카트리스트 컨트롤러로 들어옴>>>");
		Cart cart = new Cart();
		cart.setMember_id(2); // 임시 회원번호, 나중에는 세션 이용
		
		List<Cart> cartList = null;
		try {
			cartList = cartService.selectCartList(cart);
		} catch(Exception e) {
			return web.redirect(null, e.getLocalizedMessage());
		}
		
		List<Product> productList = new ArrayList<Product>();
		Product product = new Product();
		if(cartList != null) {
			for(Cart c : cartList) {
				System.out.println("<<<가져온 카트>>>");
				System.out.println("cart [id: " + c.getId() + ", member_id: " + c.getMember_id() + ", product_id: " + c.getProduct_id() + ", order_id: " + c.getOrder_id() + "]");
				product.setId(c.getProduct_id());
				
				try {
					product = productService.selectProduct(product);
				} catch (Exception e) {
					return web.redirect(null, e.getLocalizedMessage());
				}
				
				System.out.println("<<<가져온 프로덕트 정보>>>");
				System.out.println("product [id: " + product.getId() + ", name: " + product.getName() + "]");
				
				productList.add(product);
				System.out.println("<<<프로덕트 하나를 프로덕트 리스트에 담음>>>");
			}
		}
		
		model.addAttribute("cartList", cartList);
		model.addAttribute("productList", productList);
		System.out.println("<<<모델에 카트리스트, 프로덕트리스트 추가함>>>");
		
		System.out.println("<<<장바구니 jsp로 가자!!!>>>");
		return new ModelAndView("user/cart/memberCartList");
	}
	
}
