/*
 * L.Control.Title is used for displaying title on the map (added by default).
 * Based on L.Control.Attribution
 */

L.Control.Title = L.Control.extend({
	options: {
		position: 'topleft',
		prefix: ''
	},

	initialize: function (options) {
		L.setOptions(this, options);

		this._titles = {};
	},

	onAdd: function (map) {
		this._container = L.DomUtil.create('div', 'leaflet-control-title');
		if (L.DomEvent) {
			L.DomEvent.disableClickPropagation(this._container);
		}

		// TODO ugly, refactor
		for (var i in map._layers) {
			if (map._layers[i].getTitle) {
				this.addTitle(map._layers[i].getTitle());
			}
		}

		this._update();

		return this._container;
	},

	setPrefix: function (prefix) {
		this.options.prefix = prefix;
		this._update();
		return this;
	},

	addTitle: function (text) {
		if (!text) { return this; }

		if (!this._titles[text]) {
			this._titles[text] = 0;
		}
		this._titles[text]++;

		this._update();

		return this;
	},

	removeTitle: function (text) {
		if (!text) { return this; }

		if (this._titles[text]) {
			this._titles[text]--;
			this._update();
		}

		return this;
	},

	_update: function () {
		if (!this._map) { return; }

		var attribs = [];

		for (var i in this._titles) {
			if (this._titles[i]) {
				attribs.push(i);
			}
		}

		var prefixAndAttribs = [];

		if (this.options.prefix) {
			prefixAndAttribs.push(this.options.prefix);
		}
		if (attribs.length) {
			prefixAndAttribs.push(attribs.join(', '));
		}

		this._container.innerHTML = prefixAndAttribs.join(' | ');
	}
});

L.Map.mergeOptions({
	titleControl: true
});

L.Map.addInitHook(function () {
	if (this.options.titleControl) {
		this.titleControl = (new L.Control.Title()).addTo(this);
	}
});

L.control.title = function (options) {
	return new L.Control.Title(options);
};

