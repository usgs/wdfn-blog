$(document).ready(function(){
  
  var dict = {};
  
  var header = '<h3 class="extraResourcesHeader">Github repositories mentioned in this blog</h3>';
  if('article a[href*="https://github.com"]'){
    $('#extraResources').append(header);
  }
  
  $('article a[href*="https://github.com"]').each(function(index, data) {
    dict = $(data).text();
    if(dict !== ''){
      var content = '<div class="mentionedRepo">';
      content += '<a href="' + dict + '" target="_blank">';
      content += '<div class="repoName"><p>' + dict + '</p></div>';
      content += '<div class="repoImage"><img src="/images/github.svg" alt="github logo"/></div>';
      content += '</div>';
      content += '</a>';
      $('#extraResources').append(content);
    }
  });
  
  
});