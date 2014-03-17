
PROJECT=one-way-3-state-level-shifter
SCHEMATIC_X=schematic
LAYOUT_X=layout
BUILD=build
PDF_PRODUCTS = $(SCHEMATIC_X).pdf $(LAYOUT_X).pdf
PNG_PRODUCTS = $(SCHEMATIC_X).png $(LAYOUT_X).png
DISPLAY_PRODUCTS = $(PNG_PRODUCTS)

default: $(DISPLAY_PRODUCTS)

$(BUILD):
	mkdir -p build

distclean: clean
	rm -vf $(DISPLAY_PRODUCTS)

clean:
	rm -rvf $(BUILD)

$(SCHEMATIC_X).pdf: $(BUILD)/schematic.pdf
	cp $^ $@

$(LAYOUT_X).pdf: $(BUILD)/layout.pdf
	cp $^ $@

$(SCHEMATIC_X).png: $(BUILD)/schematic.png
	cp $^ $@

$(LAYOUT_X).png: $(BUILD)/layout.png
	cp $^ $@




$(BUILD)/schematic.pdf: $(PROJECT).sch | $(BUILD)
	gaf export -o $@ $^

$(BUILD)/schematic.png: $(BUILD)/schematic.pdf | $(BUILD)
	convert -density 200x200 $^ -scale 40% $@

$(BUILD)/layout.ps: $(PROJECT).pcb | $(BUILD)
	pcb -x ps --psfile $@ $^

$(BUILD)/layout.pdf: $(BUILD)/layout.ps | $(BUILD)
	ps2pdf $^ $@

$(BUILD)/layout.eps: $(PROJECT).pcb | $(BUILD)
	pcb -x eps --eps-file $@ $^

$(BUILD)/layout.png: $(BUILD)/layout.eps | $(BUILD)
	convert -density 600x600 $^ -background white -flatten $@

