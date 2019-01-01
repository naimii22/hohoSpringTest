<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ page session="true" %>
<!doctype html>
<html lang='ko'>
<head>
	<%@ include file="/WEB-INF/inc/head.jsp" %>
	<title>productCartList</title>
</head>
<body>
	<%@ include file="/WEB-INF/inc/topbar.jsp" %>
	
	<div class="container">
		<h1 class="page-header">장바구니</h1>
		
		<!-- 장바구니 목록 시작 -->
		<div class="table-responsive">
			<table id="cartTable" class="table table-hover">
				<thead>
		        	<tr>
		            	<th class="text-center" style="width: 100px">사진</th>
		            	<th class="text-center">이름</th>
		            	<th class="text-center" style="width: 120px">수량</th>
		            	<th class="text-center" style="width: 100px">금액</th>
		            	<th class="text-center" style="width: 120px">선택</th>
		        	</tr>
		    	</thead>
			    <%-- <tbody>
			    	스크립트로 해야함
			    	<c:choose>
			    		<c:when test="${fn:length(cartList) > 0}">
			    			<c:forEach var="cart" items="${cartList}" varStatus="status">
			    				<c:set var="product" value="${productList.get(status.index)}" />
			    				<tr id="cart_{{cart.id}}">
						            <td>
						            	productView.do 작성 후에 수정
						            	<c:url var="readUrl" value="user/product/productView.do">
						            		<c:param name="product_id" value="${product.id}" />
						            	</c:url>
						            	<a href="${readUrl}"><img src="${product.image}"></a>
						            	${product.image}
						            </td>
						            <td class="text-center">${product.name}</td>
						            <td class="text-center">수량</td>
						            <td class="text-center">${product.price}</td>
						            <td>
						            	<!-- 삭제하기 버튼 -->
						            	<!-- <a data-toggle="modal" href="#cartDeleteModal" class="btn btn-danger">삭제하기</a> -->
						            	<a href="${pageContext.request.contextPath}/user/cart/memberCartDelete.do?id=${cart.id}"
						            		data-toggle="modal" data-target="#cartDeleteModal" class="btn btn-danger">삭제하기</a>
						            </td>
					        	</tr>
			    			</c:forEach>
			    		</c:when>
			    		<c:otherwise>
			    			<tr>
					            <td colspan="5" class="text-center" style="line-height: 100px;">장바구니에 담긴 상품이 없습니다.</td>
					        </tr>
			    		</c:otherwise>
			    	</c:choose>
			    </tbody> --%>
			</table>
		</div>
		<!--// 장바구니 목록 끝 -->
		
		<!-- 결제 버튼 시작 -->
		<div class="clearfix">
		    <div class="pull-right">
		        <%-- 나중에 세션으로 바꾸기
		        <a href="${pageContext.request.contextPath}/user/order/memberOrderInsert.do?member_id=${loginUser.user_id}" class="btn btn-primary">
		        	<span class="glyphicon glyphicon-credit-card"></span> 결제하기
		        </a> --%>
		        <a href="${pageContext.request.contextPath}/user/order/memberOrderInsert.do?member_id=2" class="btn btn-primary">
		        	<span class="glyphicon glyphicon-credit-card"></span>결제하기
		        </a>
			</div>
		</div>
		<!--// 결제 버튼 시작 끝 -->
	</div>
	
	<%@ include file="/WEB-INF/inc/footer.jsp" %>
	
	<!-- 장바구니 목록에 대한 템플릿 참조 시작 -->
	<script id="tmpl_cart_item" type="text/x-handlebars-template">
		<tr id="cart_{{id}}">
			<td>{{image}}</td>
			<td class="text-center">{{name}}</td>
			<td class="text-center">{{amount}}</td>
			<td class="text-center">{{price}}</td>
			<td>
				<a href="${pageContext.request.contextPath}/user/cart/memberCartDelete.do?id={{id}}"
					data-toggle="modal" data-target="#cartDeleteModal" class="btn btn-danger">삭제하기</a>
			</td>
		</tr>
	</script>
	<!--// 장바구니 목록에 대한 템플릿 참조 끝 -->
	
	<!-- 카트 삭제 모달 -->
	<div id="cartDeleteModal" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
			</div>
		</div>
	</div>
	<!--// 카트 삭제 모달 끝 -->
	
	<script type="text/javascript">
		$(function() {
			/** 페이지가 열리면서 동작하도록 이벤트 정의 없이 Ajax요청 */
			$.get("${pageContext.request.contextPath}/user/cart/memberCartList.do", {
				member_id: "2"	// 나중에 세션으로 수정 ${loginUser.id}
			}, function(json) {
				if (json.rt != "OK") {
					alert(json.rt);
					return false;
				}
				
				// 템플릿 HTML을 로드한다.
				var template = Handlebars.compile($("#tmpl_cart_item").html());
				
				// JSON에 포함된 '&lt;br/&gt;'을 검색에서 <br/>로 변경함. 정규표현식 /~~~/g는 문자열 전체의 의미.
				for (var i = 0; i < json.item.length; i++) {
					json.item[i].content = json.item[i].content.replace(/&lt;br\/&gt;/g, "<br/>");
					
					// 제품 아이템 항목 하나를 템플릿과 결합한다.
					var html = template(json.item[i]);
					$("#cart_list").append(html);
				}
			});
			
			$(document).on('submit', "#cartDeleteForm", function(e) {
				e.preventDefault();

				$(this).ajaxSubmit(function(json) {
					if (json.rt != "OK") {
						alert(json.rt);
						return false;
					}
					
					alert("삭제되었습니다.");
					// modal 강제로 닫기
					$("#cartDeleteModal").modal('hide');
					
					// JSON 결과에 포함된 덧글일련번호를 사용하여 삭제할 <li>의 id값을 찾는다.
					var id = json.id;
					$("#cart_" + id).remove();
				});
			});
		});
	</script>
</body>
</html>