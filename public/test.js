$.ajax({
    type: "GET",
    url: "jsonized",
    dataType: "json",
    success: function(data){
        alert(data.title) // Will alert Max
    }        
});