/**
 * @name: booNavigation.js
 * @date: Sun 16 Feb 2014
 * @author: Noemi Losada Estrella <info@noemilosada.com>
 * Creative Commons License <http://creativecommons.org/licenses/by-sa/3.0/>
 */

(function($) {

    /**
     * Default options
     *
     * @property defaults
     * @type {Object}
     */
    var defaults = {
        slideSpeed: 600,
        fadeSpeed: 200,
        delay: 500
    };

    /**
     * Config elements
     *
     * @property config
     * @type {Object}
     */
    var config = {
        item: '.navItem',
        dropdown: '.navContent',
        dropdownContent: '.navContent > li',
        itemsDelay: 300
    };

    /**
     * booNavigation plugin
     *
     * Usage:
     * $('#booNavigation').booNavigation({
     *     slideSpeed: 500,
     *     delay: 200
     * });
     *
     * @method booNavigation
     * @return {Object} this
     */
    $.fn.booNavigation = function() {
        // Initialize the plugin with the given arguments
        init.apply(this, arguments);

        return this;
    };

    /**
     * @method init
     * @params {Object} opts
     * @return {void}
     */
    function init(opts) {
        // Hide all the dropdowns
        $(config.dropdown).hide();

        // Override default options with the custom ones
        var options = $.extend({}, defaults, opts);

        // Save options for the current instance
        this.data(options);

        this.each(function(i, e) {
            var $e = $(e);

            // Set initial data properties for each menu item
            $e.find(config.item).each(function(index, element) {
                var $el = $(element);

                $el.data('height', $el.find(config.dropdown).height());
                $el.data('id', index);
            });

            // Call to the menuSlide effects function
            menuSlide($e, options);
        });
    }


    /**
     * Animation to display and hide menuSlide
     *
     * @method menuSlide
     * @param {Object} opts
     * @param {String} selector
     * @return {void}
     */
    function menuSlide(selector, opts) {
        var $previousItem = null,
            $currentItem = null,
            delayHappened = false,
            timer;

        // Reset nav content on leave navigation
        $(selector).on("mouseleave", function(e) {
            delayHappened = false;
            $(config.dropdown).slideUp(opts.slideSpeed);
        });

        $(selector).find(config.item).hover(function(e) {

            // First time we are over an item
            if (delayHappened === false) {
                timer = setTimeout(function() {
                    // Update delay and current item
                    delayHappened = true;
                    $currentItem = $(e.currentTarget);

                    // Display dropdown and content
                    $(e.currentTarget).find(config.dropdownContent).show();
                    $(e.currentTarget).find(config.dropdown).slideDown(opts.slideSpeed);
                }, opts.delay);
            } else {
                // Changing between items
                timer = setTimeout(function() {
                    if ($(e.currentTarget).data('id') !== $currentItem.data('id')) {
                        // Update current and previous items
                        $previousItem = $currentItem;
                        $currentItem = $(e.currentTarget);

                        // Apply height to the previous item and hide previous content
                        $previousItem.find(config.dropdown).height($previousItem.data('height'))
                            .end().find(config.dropdownContent).fadeOut(opts.fadeSpeed);

                        // Animate height to the current item and display current content
                        $previousItem.find(config.dropdown).animate({
                            height: $currentItem.data('height')
                        }, opts.slideSpeed, function() {
                            $currentItem.find(config.dropdown).height($currentItem.data('height'))
                                .end().find(config.dropdownContent).hide()
                                .end().find(config.dropdown).show();

                            // Hide previous item and apply his height back
                            $previousItem.find(config.dropdown).hide()
                                .end().find(config.dropdown).height($previousItem.data('height'));

                            // Display the content for the current item
                            $currentItem.find(config.dropdownContent).fadeIn(opts.fadeSpeed);
                        });
                    }
                }, config.itemsDelay);
            }

        }, function(e) {
            clearTimeout(timer);
        });
    }

})(jQuery);
