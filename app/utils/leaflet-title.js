/*
 * L.Control.Title is used for displaying title on the map (added by default).
 */

L.Control.Title = L.Control.extend({
	options: {
		position: 'topleft',
        id: '_leaflet-control-title'
	},

	initialize: function (options) {
		L.setOptions(this, options);

		this.title = '';
	},

	onAdd: function (map) {
		this._container = L.DomUtil.create('div', 'leaflet-control-title');
        this._container.id = this.options.id
		if (L.DomEvent) {
			L.DomEvent.disableClickPropagation(this._container);
		}
		this._update();
		return this._container;
	},


	addTitle: function (text) {
		if (!text) { this._title = text }
        this._title = text
		return this;
	},

	removeTitle: function () {
        this._title = ''
		return this;
	},

	_update: function () {
		if (!this._map) { return; }
		this._container.innerHTML = this._title;
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

