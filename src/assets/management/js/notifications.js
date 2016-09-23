$(document).ready(function(){

	var check = function(){


		$.ajax({
	      type:"POST",
	          url: "getnotifications/",
	          data: {"notification": true},
	          success: function(data){

	          	
	     	}
		});
	            
	   /*$.getJSON("http://gildevelopers.com/whatsit/Player_Progress/"+user+pass+".txt", function(data){
	                
	        if(parseInt($(".level").text()) != parseInt(data.level))
	        {
	            location.reload();
	        }
	    });*/
	    
	    setTimeout(check, 200);
	};
	        
	setTimeout(check, 200);
});