function BeaverSlider(settings) {
  var pthis = this;
  
  this.error = function(msg) {
    throw new Error(msg);
    return false;
  };
  
  /* all settings passed by user */
  this.settings = settings;

  if (!this.settings) return this.error("Error: no settings parameter is passed");
  if (!this.settings.structure) return this.error("Error: no structure parameter is passed");
  if (!this.settings.structure.container) return this.error("Error: no container parameter is passed");
  if (!this.settings.structure.container.id && !this.settings.structure.container.selector) return this.error("Error: no id/selector parameter is passed");
  if (!this.settings.structure.container.height) return this.error("Error: no height parameter is passed");
  if (!this.settings.structure.container.width) return this.error("Error: no width parameter is passed");
  if (!this.settings.content) return this.error("Error: no content parameter is passed");
  if (!this.settings.content.images) return this.error("Error: no images parameter is passed");
  if (!this.settings.animation) return this.error("Error: no animation parameter is passed");
  if (!this.settings.animation.effects) return this.error("Error: no effects parameter is passed");
  if (!this.settings.animation.interval) return this.error("Error: no interval parameter is passed");

  /* preload the images to avoid problems with performance */
  for (i=0;i<settings.content.images.length;i++) {
  	var img = new Image();
  	img.onload = function() { pthis.imagesLoaded++; };
  	img.src = settings.content.images[i];
  }
  
  /* HTML objects */
  var topContainer = jQuery("#" + this.settings.structure.container.id);
  
  if (!topContainer.size()) topContainer = jQuery(this.settings.structure.container.selector); 
  
  topContainer.css({ width: this.settings.structure.container.width });

  this.container = jQuery("<div>").appendTo(topContainer);
  this.areaMain = null;
  this.areaStatus = null;
  this.areaWidgets = null;
  this.areaMessage = null;
  this.areaPlayer = null;

  /* dynamic variables */
  this.imagesLoaded = 0;
  this.currentImage = 0;
  this.currentMessage = 0;
  this.stopped = false;
  this.animationNow = false;
  this.playerFadeNow = false;
  this.cells = null;
  this.currentEffect = null;
  this.run = null;
  this.messagesAnimationCounter = null;

  /* initialize of container */
  this.initialize = function(){
    this.constructAreaMain();
    this.constructAreaStatus();
    this.constructMessage();
    this.constructPlayer();

    this.initEffects();

    this.startSliding(true);
  };

  /* initialize effects */
  this.initEffects = function() {
    // all possible effects initials
    this.effects = [
      { id: 0,   group: "fade",        name: "fadeOut",                   duration: 1000,  size: null,  steps: null,  run: this.fadeOut },
      { id: 1,   group: "slide",       name: "slideLeft",                 duration: 1000,  size: null,  steps: null,  run: this.slideLeft },
      { id: 2,   group: "slide",       name: "slideRight",                duration: 1000,  size: null,  steps: null,  run: this.slideRight },
      { id: 3,   group: "slide",       name: "slideUp",                   duration: 1000,  size: null,  steps: null,  run: this.slideUp },
      { id: 4,   group: "slide",       name: "slideDown",                 duration: 1000,  size: null,  steps: null,  run: this.slideDown },
      { id: 5,   group: "chessBoard",  name: "chessBoardLeftDown",        duration: 1000,  size: 10,    steps: 10,    run: this.chessBoardLeftDown },
      { id: 6,   group: "chessBoard",  name: "chessBoardLeftUp",          duration: 1000,  size: 10,    steps: 10,    run: this.chessBoardLeftUp },
      { id: 7,   group: "chessBoard",  name: "chessBoardRightDown",       duration: 1000,  size: 10,    steps: 10,    run: this.chessBoardRightDown },
      { id: 8,   group: "chessBoard",  name: "chessBoardRightUp",         duration: 1000,  size: 10,    steps: 10,    run: this.chessBoardRightUp },
      { id: 9,   group: "chessBoard",  name: "chessBoardRandom",          duration: 1000,  size: 10,    steps: 10,    run: this.chessBoardRandom },
      { id: 10,  group: "jalousie",    name: "jalousieLeft",              duration: 1000,  size: 10,    steps: 10,    run: this.jalousieLeft },
      { id: 11,  group: "jalousie",    name: "jalousieUp",                duration: 1000,  size: 10,    steps: 10,    run: this.jalousieUp },
      { id: 12,  group: "jalousie",    name: "jalousieRight",             duration: 1000,  size: 10,    steps: 10,    run: this.jalousieRight },
      { id: 13,  group: "jalousie",    name: "jalousieDown",              duration: 1000,  size: 10,    steps: 10,    run: this.jalousieDown },
      { id: 14,  group: "jalousie",    name: "jalousieRandomHorizontal",  duration: 1000,  size: 10,    steps: 10,    run: this.jalousieRandomHorizontal },
      { id: 15,  group: "jalousie",    name: "jalousieRandomVertical",    duration: 1000,  size: 10,    steps: 10,    run: this.jalousieRandomVertical },
      { id: 16,  group: "pancake",     name: "pancakeIn",                 duration: 1000,  size: 10,    steps: 10,    run: this.pancakeIn },
      { id: 17,  group: "pancake",     name: "pancakeOut",                duration: 1000,  size: 10,    steps: 10,    run: this.pancakeOut },
      { id: 18,  group: "pancake",     name: "pancakeRandom",             duration: 1000,  size: 10,    steps: 10,    run: this.pancakeRandom },
      { id: 19,  group: "spiral",      name: "spiralIn",                  duration: 1000,  size: 10,    steps: 10,    run: this.spiralIn },
      { id: 20,  group: "spiral",      name: "spiralOut",                 duration: 1000,  size: 10,    steps: 10,    run: this.spiralOut },
      { id: 21,  group: "prison",      name: "prisonVertical",            duration: 1000,  size: 10,    steps: null,  run: this.prisonVertical },
      { id: 22,  group: "prison",      name: "prisonHorizontal",          duration: 1000,  size: 10,    steps: null,  run: this.prisonHorizontal },
      { id: 23,  group: "zoom",        name: "zoomLeftTop",               duration: 1000,  size: 10,    steps: null,  run: this.zoomLeftTop },
      { id: 24,  group: "zoom",        name: "zoomLeftBottom",            duration: 1000,  size: 10,    steps: null,  run: this.zoomLeftBottom },
      { id: 25,  group: "zoom",        name: "zoomRightTop",              duration: 1000,  size: 10,    steps: null,  run: this.zoomRightTop },
      { id: 26,  group: "zoom",        name: "zoomRightBottom",           duration: 1000,  size: 10,    steps: null,  run: this.zoomRightBottom },
      { id: 27,  group: "zoom",        name: "zoomCenter",                duration: 1000,  size: 10,    steps: null,  run: this.zoomCenter },
      { id: 28,  group: "zoom",        name: "zoomRandom",                duration: 1000,  size: 10,    steps: null,  run: this.zoomRandom },
      { id: 29,  group: "nails",       name: "nailsUp",                   duration: 1000,  size: 10,    steps: 10,    run: this.nailsUp },
      { id: 30,  group: "nails",       name: "nailsDown",                 duration: 1000,  size: 10,    steps: 10,    run: this.nailsDown },
      { id: 31,  group: "nails",       name: "nailsLeft",                 duration: 1000,  size: 10,    steps: 10,    run: this.nailsLeft },
      { id: 32,  group: "nails",       name: "nailsRight",                duration: 1000,  size: 10,    steps: 10,    run: this.nailsRight },
      { id: 33,  group: "weed",        name: "weedDownRight",             duration: 1000,  size: 10,    steps: null,  run: this.weedDownRight },
      { id: 34,  group: "weed",        name: "weedDownLeft",              duration: 1000,  size: 10,    steps: null,  run: this.weedDownLeft },
      { id: 35,  group: "weed",        name: "weedUpRight",               duration: 1000,  size: 10,    steps: null,  run: this.weedUpRight },
      { id: 36,  group: "weed",        name: "weedUpLeft",                duration: 1000,  size: 10,    steps: null,  run: this.weedUpLeft }
    ];

    // applying all user wishes about effects
    this.userEffects = new Array();

    if (this.settings.animation.effects == "random") this.userEffects = this.effects;
    else {
      var array = (typeof this.settings.animation.effects == "string")?this.settings.animation.effects.split(","):this.settings.animation.effects;

      // go through all user wishes
      for (i=0;i<array.length;i++) {
        var name, duration, size, steps;
        
        // parse string parameters
        if (typeof array[i] == "string") {
          // parse wish
          array[i] = array[i].split(":");
  
          // get every wish parameter
          name = jQuery.trim(array[i][0]);
          duration = jQuery.trim(array[i][1]);
          size = jQuery.trim(array[i][2]);
          steps = jQuery.trim(array[i][3]);
        }
        // get parameters as an object
        else {
          name = jQuery.trim(array[i].name);
          duration = jQuery.trim(array[i].duration);
          size = jQuery.trim(array[i].size);
          steps = jQuery.trim(array[i].steps);
        }

        // go through all possible elements
        for (j=0;j<this.effects.length;j++) {
          // search for the element with same name or group in array of possible effects
          if (this.effects[j].group.toLowerCase() == name.toLowerCase() || this.effects[j].name.toLowerCase() == name.toLowerCase()) {
            // add an effect
            this.userEffects.push({
              id:       this.effects[j].id,
              group:    this.effects[j].group,
              name:     this.effects[j].name,
              duration: (duration)?duration:this.effects[j].duration,
              size:     (size)?size:this.effects[j].size,
              steps:    (steps)?steps:this.effects[j].steps,
              run:      this.effects[j].run
            });
          }
        }
      }
    }
  };

  /* construct main area */
  this.constructAreaMain = function() {
    this.areaMain = jQuery("<div>").css({ "white-space": "nowrap",
                                          overflow: "hidden",
                                          height: this.settings.structure.container.height
                                        }).append(
                      jQuery("<img>").attr("src",this.settings.content.images[this.currentImage])
                                     .css({display: "inline",
                                           width: this.settings.structure.container.width + "px",
                                           height: this.settings.structure.container.height + "px",
                                           margin: 0,
                                           padding: 0,
                                           border: "none"})
                    );
    
    this.areaWidgets = jQuery("<div>").css({width: this.settings.structure.container.width,
                                            height: this.settings.structure.container.height,
                                            position: "absolute",
                                            left: 0,
                                            top: 0,
                                            "z-index": (this.settings.structure.container.zIndexWidgets)?this.settings.structure.container.zIndexWidgets:100,
                                            background: "url(about:blank)"}) //ie7-10 hover fix
                                      .hover(function(){
                                               if (pthis.playerFadeNow) return; 
                                                 
                                               jQuery(this).find("div[show='mouseover']").fadeIn(400);
                                             },
                                             function(){
                                               pthis.playerFadeNow = true;
                                               
                                               jQuery(this).find("div[show='mouseover']").fadeOut(400,function(){
                                                 pthis.playerFadeNow = false;
                                               });
                                             })
                                      .click(function(){
                                        if (pthis.settings.events && pthis.settings.events.imageClick) pthis.settings.events.imageClick(pthis);
                                      });

    this.container.css({ position: "relative" }).append(this.areaMain,this.areaWidgets);
  };

  /* construct status area */
  this.constructAreaStatus = function() {
    if (this.settings.structure.controls) {
      this.areaStatus = jQuery("<div>").append(
                          jQuery("<div>").addClass(this.settings.structure.controls.containerClass)
                        );

      if (this.settings.structure.controls.align == "center") this.areaStatus.find("div").css("text-align","center");
      else if (this.settings.status.align == "right") this.areaStatus.find("div").css("text-align","right");
      else this.areaStatus.find("div").css("text-align","left");

      for (i=0;i<this.settings.content.images.length;i++) {
        var preview = (this.settings.structure.controls.previewMode)?jQuery("<img>").attr("src",this.settings.content.images[i]):null;
        
        this.areaStatus.children("div").append(
          jQuery("<div>").addClass(this.settings.structure.controls.elementClass)
                         .attr("inarray",i)
                         .click(function(){
                           pthis.stopSliding(parseInt(jQuery(this).attr("inarray")));
                         })
                         .append(preview)
        );
      }

      this.container.append(this.areaStatus);
      this.updateStatus();
    }
  };

  /* construct the message */
  this.constructMessage = function(){
    if (this.settings.structure.messages) {
      var message = (this.settings.animation.showMessages == "random")?Math.floor(Math.random() * this.settings.content.messages.length):0;

      this.areaMessage = jQuery("<div>").css({position: "absolute",
                                              left: this.settings.structure.messages.left?this.settings.structure.messages.left:"auto",
                                              top: this.settings.structure.messages.top?this.settings.structure.messages.top:"auto",
                                              bottom: this.settings.structure.messages.bottom?this.settings.structure.messages.bottom:"auto",
                                              right: this.settings.structure.messages.right?this.settings.structure.messages.right:"auto"})
                                        .addClass(this.settings.structure.messages.containerClass)
                                        .html(this.settings.content.messages[message])
                                        .appendTo(this.areaWidgets)
                                        .click(function(){
                                          if (pthis.settings.events && pthis.settings.events.messageClick) pthis.settings.events.messageClick(pthis);
                                        });
    }
  };
  
  /* construct the player */
  this.constructPlayer = function(){
    if (this.settings.structure.player) {
      var player = jQuery("<div>").css({position: "absolute",
                                        left: this.settings.structure.player.left?this.settings.structure.player.left:"auto",
                                        right: (this.settings.structure.player.right)?this.settings.structure.player.right:"auto",
                                        top: this.settings.structure.player.top?this.settings.structure.player.top:"auto",
                                        bottom: this.settings.structure.player.bottom?this.settings.structure.player.bottom:"auto"})
                                  .attr("show",this.settings.structure.player.show)
                                  .addClass(this.settings.structure.player.containerClass);
      
      if (this.settings.structure.player.show == "mouseover") player.hide();
      
      jQuery("<div>").html(this.settings.structure.player.backText)
                     .appendTo(player)
                     .addClass(this.settings.structure.player.backClass)
                     .click(function(){
                       if (pthis.animationNow) return;
                       
                       if (pthis.settings.events && pthis.settings.events.prev) pthis.settings.events.prev(pthis);
                       
                       pthis.stopSliding((--pthis.currentImage < 0)?(pthis.settings.content.images.length - 1):pthis.currentImage);
                     });
      
      jQuery("<div>").html(this.settings.structure.player.pauseText)
                     .appendTo(player)
                     .addClass(this.settings.structure.player.pauseClass)
                     .click(function(player){
                       if (pthis.settings.events && pthis.settings.events.stop) pthis.settings.events.stop(pthis);
                       
                       pthis.stopSliding(false);
                     });
      
      jQuery("<div>").html(this.settings.structure.player.playText)
                     .appendTo(player)
                     .addClass(this.settings.structure.player.playClass)
                     .hide()
                     .click(function(player){
                       if (pthis.animationNow) return;
                       
                       if (pthis.settings.events && pthis.settings.events.start) pthis.settings.events.start(pthis);
                       
                       pthis.startSliding(false);
                     });
       
      jQuery("<div>").html(this.settings.structure.player.forwardText)
                     .appendTo(player)
                     .addClass(this.settings.structure.player.forwardClass)
                     .click(function(player){
                       if (pthis.animationNow) return;
                       
                       if (pthis.settings.events && pthis.settings.events.next) pthis.settings.events.next(pthis);
                       
                       pthis.stopSliding((++pthis.currentImage == pthis.settings.content.images.length)?0:pthis.currentImage);
                     });
      
      this.areaWidgets.append(player);
      
      this.areaPlayer = player;
    }
  };

  this.startSliding = function(delay) {
    this.stopped = false;
    
    if (this.areaPlayer && this.areaPlayer.size()) {
  	  this.areaPlayer.children("div:eq(1)").show();
  	  this.areaPlayer.children("div:eq(2)").hide();
    }

    if (delay) {
      setTimeout(function(){
        if (pthis.settings.animation.waitAllImages && pthis.imagesLoaded == pthis.settings.content.images.length) pthis.animateAutomatically();
        else pthis.animateAutomatically();//pthis.startSliding(true);
      },this.settings.animation.initialInterval?this.settings.animation.initialInterval:this.settings.animation.interval);
    }
    else this.animateAutomatically();
  };
  
  this.stopSliding = function(img) {
    this.stopped = true;
    
    if (this.areaPlayer) {
      this.areaPlayer.children("div:eq(1)").hide();
      this.areaPlayer.children("div:eq(2)").show();
    }
    
    if (this.animationNow) return;
    
    if (img || img === 0) {
      this.currentImage = img;
      this.updateStatus();
      this.animateCurrent(function() {});
    }
  };
  
  /* initializes a chessboard with current picture */
  this.drawCells = function(xsize,ysize){
    this.cells = new Array();

    this.areaChessboard = jQuery("<div>").css({width: this.settings.structure.container.width,
                                               height: this.settings.structure.container.height,
                                               position: "absolute",
                                               left: 0,
                                               top: 0,
                                               "z-index": (this.settings.structure.container.zIndexScreen)?this.settings.structure.container.zIndexScreen:90 });

    var cellWidth = Math.floor(this.settings.structure.container.width/xsize),
        cellHeight = Math.floor(this.settings.structure.container.height/ysize),
        bigWidthCellNumber = this.settings.structure.container.width%xsize,
        bigHeightCellNumber = this.settings.structure.container.height%ysize,
        paddingLeft = 0,
        paddingTop = 0;

    for (i=0;i<ysize;i++) {
      for (j=0;j<xsize;j++) {
        var currentWidth = cellWidth + ((bigWidthCellNumber > j)?1:0),
            currentHeight = cellHeight + ((bigHeightCellNumber > i)?1:0);

        this.areaChessboard.append(
          jQuery("<div>").css({width: currentWidth + "px",
                               height: currentHeight + "px",
                               "float": "left",
                               margin: 0,
                               overflow: "hidden",
                               visibility: "hidden",
                               position: "relative"})
                         .attr({ chessboardx: j, chessboardy: i}).append(
            jQuery("<div>").css({width: currentWidth + "px",
                                 height: currentHeight + "px",
                                 overflow: "hidden",
                                 visibility: "hidden",
                                 position: "absolute"})
                           .append(
              jQuery("<img>").css({width: this.width,
                                   height: this.height,
                                   position: "absolute",
                                   left: paddingLeft + "px",
                                   top: paddingTop + "px"})
                             .attr("src",this.settings.content.images[this.currentImage])
          
            )
          )
        );

        paddingLeft = (j == xsize - 1)?0:(paddingLeft - currentWidth);
      }

      paddingTop -= currentHeight;
    }

    this.container.append(this.areaChessboard);
  };

  /* shows set of cells */
  this.removeCells = function(){
    if (this.areaChessboard) {
      this.areaMain.find("img:first").attr("src",this.settings.content.images[this.currentImage]);
      this.areaChessboard.fadeOut(50,function(){ $(this).remove(); });
      
      this.areaChessboard = false;

      return true;
    }
    
    return false;
  };

  /* fade set of cells */
  this.fadeCells = function(iteration,callback){
    var index = iteration?iteration:0,
        steps = this.currentEffect.steps * 1;

    setTimeout(function(){
      if (index >= pthis.cells.length) {
        if (index == pthis.cells.length + steps) {
          pthis.removeCells();
          callback();

          return;
        }
      }
      else pthis.cells[index].css("visibility","visible").children().css("visibility","visible").css("opacity",1/steps);

      index++;

      for (i=1;i<steps;i++)
        if (pthis.cells[index - i])
          pthis.cells[index - i].children().css("opacity",(i + 1)/steps);

      pthis.fadeCells(index,callback);
    },this.currentEffect.duration/(this.currentEffect.size * 1 + steps - 1));
  };
  
  /* slide set of cells */
  this.slideCells = function(up,down,left,right,iteration,callback){
    var index = iteration?iteration:0,
        steps = this.currentEffect.steps * 1;

    setTimeout(function(){
      if (index >= pthis.cells.length) {
        if (index == pthis.cells.length + steps) {
          pthis.removeCells();
          callback();

          return;
        }
      }
      else pthis.cells[index].children().each(function(){
        $(this).css("visibility","visible").css("opacity",1/steps);
        
        if (up) $(this).css("top",$(this).innerHeight() + "px");
        if (down) $(this).css("top",-$(this).innerHeight() + "px");
        if (left) $(this).css("left",$(this).innerHeight() + "px");
        if (right) $(this).css("left",$(this).innerHeight() + "px");
      });

      index++;

      for (i=1;i<=steps;i++)
        if (pthis.cells[index - i]) {
          pthis.cells[index - i].children().each(function(){
            var h = $(this).innerHeight(),w = $(this).innerWidth();
            
            if (up) $(this).css("top",h * (1 - i/steps) + "px");
            if (down) $(this).css("top",- h * (1 - i/steps) + "px");
            if (left) $(this).css("left",w * (1 - i/steps) + "px");
            if (right) $(this).css("left",- w * (1 - i/steps) + "px");
            
            $(this).css("opacity",(i + 1)/steps);
          });
        }

      pthis.slideCells(up,down,left,right,index,callback);
    },this.currentEffect.duration/(this.currentEffect.size * 1 + steps - 1));
  };

  /* set status to current image */
  this.updateStatus = function() {
    if (!this.areaStatus) return;
    
    setTimeout(function() {
      pthis.areaStatus
           .children("div")
           .children("div").removeClass(pthis.settings.structure.controls.elementActiveClass)
                           .addClass(pthis.settings.structure.controls.elementClass) 
           .eq(pthis.currentImage).removeClass(pthis.settings.structure.controls.elementClass)
                                      .addClass(pthis.settings.structure.controls.elementActiveClass);
    },1);
  };

  /* get next image */
  this.nextImage = function() {
    this.currentImage = (this.currentImage == this.settings.content.images.length - 1)?0:(this.currentImage + 1);
    this.updateStatus();
  };
  
  /* animation driver: zoom */
  this.startzoom = function(left,top,callback) {
    this.areaMain.find("img:first").attr("src",pthis.settings.content.images[pthis.currentImage])
                                   .css("display","block")
                                   .animate(
                                     { width: Math.round((1 + this.currentEffect.size/100) * this.settings.structure.container.width) + "px",
                                       height: Math.round((1 + this.currentEffect.size/100) * this.settings.structure.container.height) + "px",
                                       marginLeft: Math.round(-1 * left * this.settings.structure.container.width) + "px",
                                       marginTop: Math.round(-1 * top * this.settings.structure.container.height) + "px"},
                                     parseInt(this.currentEffect.duration),
                                     function() {
                                       jQuery(this).css({
                                                     width: pthis.settings.structure.container.width + "px",
                                                     height: pthis.settings.structure.container.height + "px",
                                                     "margin-left": 0,
                                                     "margin-top": 0
                                                   });
                                       callback();
                                     }
                                   );
  };
  
  this.zoomLeftTop = function(callback) {
    this.startzoom(0,0,callback);
  };

  this.zoomRightTop = function(callback) {
    this.startzoom(this.currentEffect.size/100,0,callback);
  };
  
  this.zoomLeftBottom = function(callback) {
    this.startzoom(0,this.currentEffect.size/100,callback);
  };
  
  this.zoomRightBottom = function(callback) {
    this.startzoom(this.currentEffect.size/100,this.currentEffect.size/100,callback);
  };
  
  this.zoomCenter = function(callback) {
    this.startzoom(this.currentEffect.size/100/2,this.currentEffect.size/100/2,callback);
  };
  
  this.zoomRandom = function(callback) {
    this.startzoom(Math.random() * this.currentEffect.size/100,Math.random() * this.currentEffect.size/100,callback);
  };
  
  /* animation: slideLeft */
  this.slideLeft = function(callback) {
    jQuery("<img>").attr("src",this.settings.content.images[this.currentImage]).appendTo(this.areaMain);

    this.areaMain.find("img:first").animate(
      { marginLeft: '-' + this.settings.structure.container.width + "px" },
      parseInt(this.currentEffect.duration),
      function() {
        jQuery(this).remove();
        callback();
      }
    );
  };

  /* animation: slideRight */
  this.slideRight = function(callback) {
    jQuery("<img>").attr("src",this.settings.content.images[this.currentImage]).css("margin-left","-" + this.settings.structure.container.width + "px").insertBefore(this.areaMain.children("img:first"));

    this.areaMain.find("img:first").animate(
      { marginLeft: "0" },
      parseInt(this.currentEffect.duration),
      function() {
        jQuery(this).next().remove();
        callback();
      }
    );
  };

  /* animation: slideUp */
  this.slideUp = function(callback) {
    this.areaMain.css("white-space","normal").append(
      jQuery("<img>").attr("src",this.settings.content.images[this.currentImage]).css("display","block")
    );

    this.areaMain.find("img:first").css("display","block")
                                   .animate(
                                     { marginTop: '-' + this.settings.structure.container.height + "px" },
                                     parseInt(this.currentEffect.duration),
                                     function() {
                                       jQuery(this).next().css("display","inline");
                                       jQuery(this).remove();
                                       callback();
                                     }
                                   );

    this.areaMain.css("white-space","nowrap");
  };

  /* animation: slideDown*/
  this.slideDown = function(callback) {
    this.areaMain.css("white-space","normal").find("img:first").css("display","block");

    jQuery("<img>").css("display","block").attr("src",this.settings.content.images[this.currentImage]).css("margin-top","-" + this.settings.structure.container.height + "px").insertBefore(this.areaMain.find("img:first"));

    this.areaMain.find("img:first").animate(
      { marginTop: "0" },
      parseInt(this.currentEffect.duration),
      function() {
        jQuery(this).css("display","inline");
        jQuery(this).next().remove();
        callback();
      }
    );

    this.areaMain.css("white-space","nowrap");
  };

  /* animation: fadeOut*/
  this.fadeOut = function(callback) { 
    jQuery("<img>").css({ position: "absolute" })
                   .attr("src",this.settings.content.images[this.currentImage])
                   .insertBefore(this.areaMain.find("img:first"))
                   .fadeOut(0)
                   .fadeIn(parseInt(this.currentEffect.duration),function(){
                     jQuery(this).css("position","static");
                     jQuery(this).css("display","inline");
                     jQuery(this).next().remove();
                     callback();
                   });
  };

  /* animation: chessBoardRightDown*/
  this.chessBoardRightDown = function(callback) {
    this.drawCells(this.currentEffect.size,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size * 2 - 1;i++) {
      for (j=0;j<this.currentEffect.size;j++) {
        for (k=0;k<this.currentEffect.size;k++) {
          if (j + k == i) {
            var element = allnetimages.filter("div[chessboardx='" + j + "'][chessboardy='" + k + "']");

            this.cells[i] = this.cells[i]?this.cells[i].add(element):element;
          }
        }
      }
    }

    this.fadeCells(false,callback);
  };

  /* animation: chessBoardLeftDown */
  this.chessBoardLeftDown = function(callback) {
    this.drawCells(this.currentEffect.size,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size * 2 - 1;i++) {
      for (j=0;j<this.currentEffect.size;j++) {
        for (k=0;k<this.currentEffect.size;k++) {
          if ((this.currentEffect.size - j - 1) + k == i) {
            var element = allnetimages.filter("div[chessboardx='" + j + "'][chessboardy='" + k + "']");

            this.cells[i] = this.cells[i]?this.cells[i].add(element):element;
          }
        }
      }
    }

    this.fadeCells(false,callback);
  };

  /* animation: chessBoardLeftUp */
  this.chessBoardLeftUp = function(callback) {
    this.drawCells(this.currentEffect.size,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size * 2 - 1;i++) {
      for (j=0;j<this.currentEffect.size;j++) {
        for (k=0;k<this.currentEffect.size;k++) {
          if (this.currentEffect.size * 2 - j - k - 2 == i) {
            var element = allnetimages.filter("div[chessboardx='" + j + "'][chessboardy='" + k + "']");

            this.cells[i] = this.cells[i]?this.cells[i].add(element):element;
          }
        }
      }
    }

    this.fadeCells(false,callback);
  };

  /* animation: chessBoardRightUp */
  this.chessBoardRightUp = function(callback) {
    this.drawCells(this.currentEffect.size,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size * 2 - 1;i++) {
      for (j=0;j<this.currentEffect.size;j++) {
        for (k=0;k<this.currentEffect.size;k++) {
          if (j + (this.currentEffect.size - k - 1) == i) {
            var element = allnetimages.filter("div[chessboardx='" + j + "'][chessboardy='" + k + "']");

            this.cells[i] = this.cells[i]?this.cells[i].add(element):element;
          }
        }
      }
    }

    this.fadeCells(false,callback);
  };

  /* animation: chessBoardRandom */
  this.chessBoardRandom = function(callback) {
    this.drawCells(this.currentEffect.size,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div"),
        array = new Array(),
        elementsCount = this.currentEffect.size * this.currentEffect.size;

    for (i=0;i<this.currentEffect.size;i++)
      for (j=0;j<this.currentEffect.size;j++)
        array[i * this.currentEffect.size + j] = i + "," + j;

    for (i=0;i<this.currentEffect.size;i++) {
      for (j=0;j<this.currentEffect.size;j++) {
        var current = Math.floor(Math.random() * elementsCount)%array.length,
            element = 0,
            last;

        while (current != -1) {
          if (array[element]) {
            current--;
            last = element;
          }

          element = (element == array.length - 1)?0:(element + 1);
        }

        var result = array[last].split(",");

        array[last] = false;

        var element = allnetimages.filter("div[chessboardx='" + result[0] + "'][chessboardy='" + result[1] + "']");
                         
        this.cells[i] = this.cells[i]?this.cells[i].add(element):element;
      }
    }

    this.fadeCells(false,callback);
  };

  /* animation: jalousieRight */
  this.jalousieRight = function(callback) {
    this.drawCells(this.currentEffect.size,1);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size;i++) {
      var element = allnetimages.filter("div[chessboardx='" + i + "']");
      this.cells[i] = element;
    }

    this.fadeCells(false,callback);
  };

  /* animation: jalousieDown */
  this.jalousieDown = function(callback) {
    this.drawCells(1,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size;i++) {
      var element = allnetimages.filter("div[chessboardy='" + i + "']");
      this.cells[i] = element;
    }

    this.fadeCells(false,callback);
  };

  /* animation: jalousieLeft */
  this.jalousieLeft = function(callback) {
    this.drawCells(this.currentEffect.size,1);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size;i++) {
      var element = allnetimages.filter("div[chessboardx='" + (this.currentEffect.size - i - 1) + "']");
      this.cells[i] = element;
    }

    this.fadeCells(false,callback);
  };

  /* animation: jalousieUp */
  this.jalousieUp = function(callback) {
    this.drawCells(1,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size;i++) {
      var element = allnetimages.filter("div[chessboardy='" + (this.currentEffect.size - i - 1) + "']");
      this.cells[i] = element;
    }

    this.fadeCells(false,callback);
  };

  /* animation: jalousieRandomHorizontal */
  this.jalousieRandomHorizontal = function(callback) {
    this.drawCells(this.currentEffect.size,1);

    var allnetimages = this.areaChessboard.find("div"),
        array = new Array();

    for (i=0;i<this.currentEffect.size;i++) array[i] = i + "," + "1";

    for (i=0;i<this.currentEffect.size;i++) {
      var current = Math.floor(Math.random() * this.currentEffect.size)%array.length,
          element = 0,
          last;

      while (current != -1) {
        if (array[element]) {
          current--;
          last = element;
        }

        element = (element == array.length - 1)?0:(element + 1);
      }

      var element = allnetimages.filter("div[chessboardx='" + array[last].split(",")[0] + "']");

      array[last] = false;
      this.cells[i] = this.cells[i]?this.cells[i].add(element):element;
    }

    this.fadeCells(false,callback);
  };

  /* animation: jalousieRandomVertical */
  this.jalousieRandomVertical = function(callback) {
    this.drawCells(1,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div"),
        array = new Array();

    for (i=0;i<this.currentEffect.size;i++) array[i] = i + "," + "1";

    for (i=0;i<this.currentEffect.size;i++) {
      var current = Math.floor(Math.random() * this.currentEffect.size)%array.length,
          element = 0,
          last;

      while (current != -1) {
        if (array[element]) {
          current--;
          last = element;
        }

        element = (element == array.length - 1)?0:(element + 1);
      }

      var element = allnetimages.filter("div[chessboardy='" + array[last].split(",")[0] + "']");

      array[last] = false;
      this.cells[i] = this.cells[i]?this.cells[i].add(element):element;
    }

    this.fadeCells(false,callback);
  };
  
  /* animation: pancakeIn */
  this.pancakeIn = function(callback) {
    this.drawCells(this.currentEffect.size,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");

    for (border=0;border<Math.ceil(this.currentEffect.size/2);border++) {
      var end = this.currentEffect.size - 1 - border;
      
      for (i=0;i<this.currentEffect.size;i++) {
        for (j=0;j<this.currentEffect.size;j++) {
          if (i >= border && j >= border && i <= end && j <= end && (i == border || i == end || j == border || j == end)) {
            var element = allnetimages.filter("div[chessboardx='" + i + "'][chessboardy='" + j + "']");
            this.cells[border] = this.cells[border]?this.cells[border].add(element):element;
          }
        }
      }
    }

    this.fadeCells(false,callback);
  };
  
  /* animation: pancakeOut */
  this.pancakeOut = function(callback) {
    this.drawCells(this.currentEffect.size,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");

    for (border=Math.ceil(this.currentEffect.size/2) - 1;border>=0;border--) {
      var tmpborder = Math.ceil(this.currentEffect.size/2) - 1 - border,
          end = this.currentEffect.size - 1 - tmpborder;
      
      for (i=0;i<this.currentEffect.size;i++) {
        for (j=0;j<this.currentEffect.size;j++) {
          if (i >= tmpborder && j >= tmpborder && i <= end && j <= end && (i == tmpborder || i == end || j == tmpborder || j == end)) {
            var element = allnetimages.filter("div[chessboardx='" + i + "'][chessboardy='" + j + "']");
            this.cells[border] = this.cells[border]?this.cells[border].add(element):element;
          }
        }
      }
    }

    this.fadeCells(false,callback);
  };
  
  /* animation: pancakeRandom */
  this.pancakeRandom = function(callback) {
    this.drawCells(this.currentEffect.size,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div"),
        array = new Array();

    for (i=0;i<Math.ceil(this.currentEffect.size/2);i++) array[i] = i + "," + "1";
    
    for (border=Math.ceil(this.currentEffect.size/2) - 1;border>=0;border--) {
      
      
      var current = Math.floor(Math.random() * Math.ceil(this.currentEffect.size/2))%array.length,
          element = 0,
          last;
    
      while (current != -1) {
        if (array[element]) {
          current--;
          last = element;
        }
    
        element = (element == array.length - 1)?0:(element + 1);
      }
    
      var tmpborder = array[last].split(",")[0],
          end = this.currentEffect.size - 1 - tmpborder;

      for (i=0;i<this.currentEffect.size;i++) {
        for (j=0;j<this.currentEffect.size;j++) {
          if (i >= tmpborder && j >= tmpborder && i <= end && j <= end && (i == tmpborder || i == end || j == tmpborder || j == end)) {
            var element = allnetimages.filter("div[chessboardx='" + i + "'][chessboardy='" + j + "']");
            this.cells[border] = this.cells[border]?this.cells[border].add(element):element;
          }
        }
      }
      
      array[last] = false;
    }

    this.fadeCells(false,callback);
  };

  /* animation: spiralIn */
  this.spiralIn = function(callback) {
    this.drawCells(this.currentEffect.size,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");
    
    var all = -1;

    for (border=0;border<Math.ceil(this.currentEffect.size/2);border++) {
      var end = this.currentEffect.size - border - 1;
      
      for (i=border;i<=end;i++) {
        all++;
        
        var element = allnetimages.filter("div[chessboardx='" + i + "'][chessboardy='" + border + "']");
        
        
        this.cells[all] = this.cells[all]?this.cells[all].add(element):element;
      }
      
      for (i=border + 1;i<=end;i++) {
        all++;
        
        var element = allnetimages.filter("div[chessboardx='" + end + "'][chessboardy='" + i + "']");
        
        this.cells[all] = this.cells[all]?this.cells[all].add(element):element;
      }
      
      for (i=end - 1;i>=border;i--) {
        all++;
        
        var element = allnetimages.filter("div[chessboardx='" + i + "'][chessboardy='" + end + "']");
       
        this.cells[all] = this.cells[all]?this.cells[all].add(element):element;
      }
      
      for (i=end - 1;i>=border + 1;i--) {
        all++;
        
        var element = allnetimages.filter("div[chessboardx='" + border + "'][chessboardy='" + i + "']");
        
        this.cells[all] = this.cells[all]?this.cells[all].add(element):element;
      }
    }

    this.fadeCells(false,callback);
  };
  
  /* animation: spiralOut */
  this.spiralOut = function(callback) {
    this.drawCells(this.currentEffect.size,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");
    
    var all = -1;

    for (border=Math.ceil(this.currentEffect.size/2) - 1;border>=0;border--) {
      var end = this.currentEffect.size - border - 1;
      
      for (i=border + 1;i<=end;i++) {
        all++;
        
        var element = allnetimages.filter("div[chessboardx='" + end + "'][chessboardy='" + i + "']");
        
        this.cells[all] = this.cells[all]?this.cells[all].add(element):element;
      }
      
      for (i=end - 1;i>=border;i--) {
        all++;
        
        var element = allnetimages.filter("div[chessboardx='" + i + "'][chessboardy='" + end + "']");
       
        this.cells[all] = this.cells[all]?this.cells[all].add(element):element;
      }
      
      for (i=end - 1;i>=border + 1;i--) {
        all++;
        
        var element = allnetimages.filter("div[chessboardx='" + border + "'][chessboardy='" + i + "']");
        
        this.cells[all] = this.cells[all]?this.cells[all].add(element):element;
      }
      
      for (i=border;i<=end;i++) {
        all++;
        
        var element = allnetimages.filter("div[chessboardx='" + i + "'][chessboardy='" + border + "']");
        
        
        this.cells[all] = this.cells[all]?this.cells[all].add(element):element;
      }
    }

    this.fadeCells(false,callback);
  };
  
  /* animation: prisonVertical */
  this.prisonVertical = function(callback) {
    this.drawCells(this.currentEffect.size,1);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size;i++) {
      var element = allnetimages.filter("div[chessboardx='" + i + "']"), targetEffect;
      
      element.children()
             .css({ overflow: "hidden", visibility: "visible", opacity: 1 })
             .children()
             .css("top",((i%2 == 0)?"-":"") + this.settings.structure.container.height + "px")
             .animate(
               { top: 0 },
               parseInt(this.currentEffect.duration),
               function() {
                 if (pthis.removeCells()) callback();
               }
             );
    }
  };
  
  /* animation: prisonHorizontal */
  this.prisonHorizontal = function(callback) {
    this.drawCells(1,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size;i++) {
      var element = allnetimages.filter("div[chessboardy='" + i + "']"), targetEffect;
      
      element.children()
             .css({ overflow: "hidden", visibility: "visible", opacity: 1 })
             .children()
             .css("left",((i%2 == 0)?"-":"") + this.settings.structure.container.width + "px")
             .animate(
               { left: 0 },
               parseInt(this.currentEffect.duration),
               function() {
                 if (pthis.removeCells()) callback();
               }
             );
    }
  };
  
  /* animation: nailsUp */
  this.nailsUp = function(callback) {
    this.drawCells(1,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size;i++) {
      var element = allnetimages.filter("div[chessboardy='" + (this.currentEffect.size - i - 1) + "']");
      this.cells[i] = element;
    }

    this.slideCells(true,false,false,false,false,callback);
  };
  
  /* animation: nailsDown */
  this.nailsDown = function(callback) {
    this.drawCells(1,this.currentEffect.size);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size;i++) {
      var element = allnetimages.filter("div[chessboardy='" + (this.currentEffect.size - i - 1) + "']");
      this.cells[i] = element;
    }

    this.slideCells(false,true,false,false,false,callback);
  };
  
  /* animation: nailsLeft */
  this.nailsLeft = function(callback) {
    this.drawCells(this.currentEffect.size,1);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size;i++) {
      var element = allnetimages.filter("div[chessboardx='" + (this.currentEffect.size - i - 1) + "']");
      this.cells[i] = element;
    }

    this.slideCells(false,false,true,false,false,callback);
  };
  
  /* animation: nailsRight */
  this.nailsRight = function(callback) {
    this.drawCells(this.currentEffect.size,1);

    var allnetimages = this.areaChessboard.find("div");

    for (i=0;i<this.currentEffect.size;i++) {
      var element = allnetimages.filter("div[chessboardx='" + (this.currentEffect.size - i - 1) + "']");
      this.cells[i] = element;
    }

    this.slideCells(false,false,false,true,false,callback);
  };
  
  /* animation: weedDownRight */
  this.weedDownRight = function(callback) {
    this.drawCells(this.currentEffect.size,1);

    var allnetimages = this.areaChessboard.find("div");
    
    var implement = function(a){
      setTimeout(function(){
        allnetimages.filter("div[chessboardx='" + a + "']")
                    .children()
                    .css({ overflow: "hidden", visibility: "visible", opacity: 1 })
                    .children()
                    .css({ opacity: 0,top: "-" + pthis.settings.structure.container.height + "px" })
                    .animate(
                      { top: 0, opacity: 1 },
                      parseInt(pthis.currentEffect.duration),
                      function() {
                        if (a == pthis.currentEffect.size - 1 && pthis.removeCells()) callback();
                      }
                    );
      },a*pthis.currentEffect.duration/pthis.currentEffect.size);
    };

    for (i=0;i<this.currentEffect.size;i++) implement(i);
  };
  
  /* animation: weedDownLeft */
  this.weedDownLeft = function(callback) {
    this.drawCells(this.currentEffect.size,1);

    var allnetimages = this.areaChessboard.find("div");
    
    var implement = function(a){
      setTimeout(function(){
        allnetimages.filter("div[chessboardx='" + a + "']")
                    .children()
                    .css({ overflow: "hidden", visibility: "visible", opacity: 1 })
                    .children()
                    .css({ opacity: 0,top: "-" + pthis.settings.structure.container.height + "px" })
                    .animate(
                      { top: 0, opacity: 1 },
                      parseInt(pthis.currentEffect.duration),
                      function() {
                        if (a == 0 && pthis.removeCells()) callback();
                      }
                    );
      },(pthis.currentEffect.size - a)*pthis.currentEffect.duration/pthis.currentEffect.size);
    };

    for (i=0;i<this.currentEffect.size;i++) implement(i);
  };
  
  /* animation: weedUpRight */
  this.weedUpRight = function(callback) {
    this.drawCells(this.currentEffect.size,1);

    var allnetimages = this.areaChessboard.find("div");
    
    var implement = function(a){
      setTimeout(function(){
        allnetimages.filter("div[chessboardx='" + a + "']")
                    .children()
                    .css({ overflow: "hidden", visibility: "visible", opacity: 1 })
                    .children()
                    .css({ opacity: 0,top: pthis.settings.structure.container.height + "px" })
                    .animate(
                      { top: 0, opacity: 1 },
                      parseInt(pthis.currentEffect.duration),
                      function() {
                        if (a == pthis.currentEffect.size - 1 && pthis.removeCells()) callback();
                      }
                    );
      },a*pthis.currentEffect.duration/pthis.currentEffect.size);
    };

    for (i=0;i<this.currentEffect.size;i++) implement(i);
  };
  
  /* animation: weedUpLeft */
  this.weedUpLeft = function(callback) {
    this.drawCells(this.currentEffect.size,1);

    var allnetimages = this.areaChessboard.find("div");
    
    var implement = function(a){
      setTimeout(function(){
        allnetimages.filter("div[chessboardx='" + a + "']")
                    .children()
                    .css({ overflow: "hidden", visibility: "visible", opacity: 1 })
                    .children()
                    .css({ opacity: 0,top: pthis.settings.structure.container.height + "px" })
                    .animate(
                      { top: 0, opacity: 1 },
                      parseInt(pthis.currentEffect.duration),
                      function() {
                        if (a == 0 && pthis.removeCells()) callback();
                      }
                    );
      },(pthis.currentEffect.size - a)*pthis.currentEffect.duration/pthis.currentEffect.size);
    };

    for (i=0;i<this.currentEffect.size;i++) implement(i);
  };
  
  /* animation controller */
  this.animateAutomatically = function() {
    if (this.stopped) return;

    this.nextImage();
    
    this.animateCurrent(function() {
      setTimeout(function(){
        pthis.animateAutomatically();
      },pthis.settings.animation.interval);
    }); 
  };

  this.animateCurrent = function(callback) {
    if (this.animationNow) return;
    
    if (pthis.settings.events && this.settings.events.beforeSlide) this.settings.events.beforeSlide(pthis);
    
    this.currentEffect = this.userEffects[Math.floor(Math.random() * this.userEffects.length)];
    this.run = this.currentEffect.run;
    
    this.animationNow = true;
    
    if (pthis.settings.events && this.settings.events.afterSlideStart) this.settings.events.afterSlideStart(pthis);
    
    this.run(function() {
      pthis.animationNow = false;
      
      if (pthis.settings.events && pthis.settings.events.beforeSlideEnd) pthis.settings.events.beforeSlideEnd(pthis);
      
      if (callback) callback();
      
      if (pthis.settings.events && pthis.settings.events.afterSlide) pthis.settings.events.afterSlide(pthis);
    });
    
    if (pthis.settings.events && this.settings.events.beforeMessageChange) this.settings.events.beforeMessageChange(pthis); 	
  	
    // current message
    if (this.settings.content.messages) {
      if (settings.animation.showMessages == "random") {
        this.currentMessage = Math.floor(Math.random() * this.settings.content.messages.length);
        this.messagesAnimationCounter = 1;
      }
      else if (settings.animation.showMessages == "linked") {
        this.currentMessage = this.currentImage;
        this.messagesAnimationCounter = 1;
      }
      else {
        if (!this.messagesAnimationCounter || this.messagesAnimationCounter == 1) {
          this.messagesAnimationCounter = this.settings.animation.changeMessagesAfter;
          this.currentMessage = (++this.currentMessage == this.settings.content.messages.length)?0:this.currentMessage;
        }
        else this.messagesAnimationCounter--;
      }
    }
    // end of current message
    
    if (this.messagesAnimationCounter == 1) this.areaMessage.html(this.settings.content.messages[this.currentMessage]);
    
    if (pthis.settings.events && this.settings.events.afterMessageChange) this.settings.events.afterMessageChange(pthis);
  };
  
  if (pthis.settings.events && this.settings.events.beforeInitialize) this.settings.events.beforeInitialize(pthis);

  this.initialize();
  
  if (pthis.settings.events && this.settings.events.afterInitialize) this.settings.events.afterInitialize(pthis);
}