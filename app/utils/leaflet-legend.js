/*
 * L.Control.Legend is used for displaying legend on the map (added by default).
 */

L.Control.Legend = L.Control.extend({
	options: {
		position: 'bottomleft',
        id: '_leaflet-control-legend'
	},

	initialize: function (options) {
		L.setOptions(this, options);
        this._legend = '';
	},

	onAdd: function (map) {
		this._container = L.DomUtil.create('div', 'leaflet-control-legend');
        this._container.id = this.options.id
		if (L.DomEvent) {
			L.DomEvent.disableClickPropagation(this._container);
		}
		this._update();
		return this._container;
	},


	addLegend: function (text) {
		if (!text) { return this; }
        this._legend = text
		return this;
	},

	removeLegend: function (text) {
		if (!text) { return this; }
        this._legend = ''
		return this;
	},

	_update: function () {
		if (!this._map) { return; }
		this._container.innerHTML = this._legend;
	}
});

L.Map.mergeOptions({
	legendControl: true
});

L.Map.addInitHook(function () {
	if (this.options.legendControl) {
		this.legendControl = (new L.Control.Legend()).addTo(this);
	}
});

L.control.legend = function (options) {
	return new L.Control.Legend(options);
};

