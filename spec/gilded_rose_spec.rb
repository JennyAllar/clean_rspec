require "spec_helper"
require "./lib/gilded_rose"

RSpec.describe GildedRose do
  subject(:gilded_rose) { described_class.new }
  let(:name) { 'Normal Item' }

  it "is a gilded rose" do
    expect(gilded_rose).to be_a(GildedRose)
  end

  describe '#tick' do
    context 'with a normal item' do
      subject { described_class.new(name: 'Normal Item', days_remaining: days_remaining, quality: quality) }
      context 'when the days remaining is less than 11' do
        let(:days_remaining) { -10 }
        let(:quality) { 10 }

        before do
          subject.tick
        end

        it "lowers the quality score" do
          expect(subject.quality).to eq(8)
        end

        it 'increases the days remaining by one' do
          expect(subject.days_remaining).to eq(-11)
        end
      end

      context 'when the days remaining is 0' do
        let(:days_remaining) { 0 }
        let(:quality) { 10 }

        before do
          subject.tick
        end

        it "lowers the quality score by two" do
          expect(subject.quality).to eq(8)
        end

        it 'increases sets the days remaining to a negative' do
          expect(subject.days_remaining).to eq(-1)
        end
      end
    end
  end

  shared_examples :gilded_rose do |name, days_remaining, quality, expected_days_remaining, expected_quality|
    it 'ticks' do
      gr = GildedRose.new(name: name, days_remaining: days_remaining, quality: quality)
      gr.tick
      expect(gr).to have_attributes(days_remaining: expected_days_remaining, quality: expected_quality)
    end
  end

  it "normal item before sell date" do
    gr = GildedRose.new(name: "Normal Item", days_remaining: 5, quality: 10)
    gr2 = GildedRose.new(name: "Normal Item", days_remaining: -1, quality: 8)
    gr3 = GildedRose.new(name: "Normal Item", days_remaining: 1, quality: 12)

    gr.tick

    expect(gr).to have_attributes(days_remaining: 4, quality: 9)
  end

  it "normal item on sell date" do
    gr = GildedRose.new(name: "Normal Item", days_remaining: 0, quality: 10)

    expect(gr).to be_instance_of(GildedRose) 

    gr.tick

    expect(gr.days_remaining).to eq(-1)
    expect(gr.quality).to eq(8)
  end

  it "normal item of zero quality" do
    gr = GildedRose.new(name: name, days_remaining: 5, quality: 0)

    gr.tick

    expect(gr.days_remaining).to eq(4)
    expect(gr.quality).to eq(0)
  end

  it_behaves_like :gilded_rose, "Aged Brie", 5, 10, 4, 11
  it_behaves_like :gilded_rose, "Aged Brie", 5, 50, 4, 50
  it_behaves_like :gilded_rose, "Aged Brie", 0, 10, -1, 12
  it_behaves_like :gilded_rose, "Aged Brie", 0, 49, -1, 50
  it_behaves_like :gilded_rose, "Aged Brie", 0, 50, -1, 50
  it_behaves_like :gilded_rose, "Aged Brie", -10, 10, -11, 12
  it_behaves_like :gilded_rose, "Aged Brie", -10, 50, -11, 50

  it "sulfuras before sell date" do
    gr = GildedRose.new(name: "Sulfuras, Hand of Ragnaros", days_remaining: 5, quality: 80)

    gr.tick

    expect(gr.days_remaining).to eq(5)
    expect(gr.quality).to eq(80)
  end

  it "sulfuras on sell date" do
    gr = GildedRose.new(name: "Sulfuras, Hand of Ragnaros", days_remaining: 0, quality: 80)

    gr.tick

    expect(gr.days_remaining).to eq(0)
    expect(gr.quality).to eq(80)
  end

  it "sulfuras after sell date" do
    gr = GildedRose.new(name: "Sulfuras, Hand of Ragnaros", days_remaining: -10, quality: 80)

    gr.tick

    expect(gr.days_remaining).to eq(-10)
    expect(gr.quality).to eq(80)
  end

  it "backstage passes long before sell date" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 11, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(10)
    expect(gr.quality).to eq(11)
  end

  it "backstage passes long before sell date at max quality" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 11, quality: 50)

    gr.tick

    expect(gr).to have_attributes(days_remaining: 10, quality: 50)
  end

  it "backstage passes medium close to sell date upper bound" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 10, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(9)
    expect(gr.quality).to eq(12)
  end

  it "backstage passes medium close to sell date upper bound at max quality" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 10, quality: 50)

    gr.tick

    expect(gr.days_remaining).to eq(9)
    expect(gr.quality).to eq(50)
  end

  it "backstage passes medium close to sell date lower bound" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 6, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(5)
    expect(gr.quality).to eq(12)
  end

  it "backstage passes medium close to sell date lower bound at max quality" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 6, quality: 50)

    gr.tick

    expect(gr.days_remaining).to eq(5)
    expect(gr.quality).to eq(50)
  end

  it "backstage passes very close to sell date upper bound" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 5, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(4)
    expect(gr.quality).to eq(13)
  end

  it "backstage passes very close to sell date upper bound at max quality" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 5, quality: 50)

    gr.tick

    expect(gr.days_remaining).to eq(4)
    expect(gr.quality).to eq(50)
  end

  it "backstage passes very close to sell date lower bound" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 1, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(0)
    expect(gr.quality).to eq(13)
  end

  it "backstage passes very close to sell date lower bound at max quality" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 1, quality: 50)

    gr.tick

    expect(gr.days_remaining).to eq(0)
    expect(gr.quality).to eq(50)
  end

  it "backstage passes on sell date" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: 0, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(-1)
    expect(gr.quality).to eq(0)
  end

  it "backstage passes after sell date" do
    gr = GildedRose.new(name: "Backstage passes to a TAFKAL80ETC concert", days_remaining: -10, quality: 10)
# 
    gr.tick

    expect(gr.days_remaining).to eq(-11)
    expect(gr.quality).to eq(0)
  end

  xit "conjured mana before sell date" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 5, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(4)
    expect(gr.quality).to eq(8)
  end

  xit "conjured mana before sell date at zero quality" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 5, quality: 0)

    gr.tick

    expect(gr.days_remaining).to eq(4)
    expect(gr.quality).to eq(0)
  end

  xit "conjured mana on sell date" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 0, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(-1)
    expect(gr.quality).to eq(6)
  end

  xit "conjured mana on sell date at zero quality" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: 0, quality: 0)

    gr.tick

    expect(gr.days_remaining).to eq(-1)
    expect(gr.quality).to eq(0)
  end

  xit "conjured mana after sell date" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: -10, quality: 10)

    gr.tick

    expect(gr.days_remaining).to eq(-11)
    expect(gr.quality).to eq(6)
  end

  xit "conjured mana after sell date at zero quality" do
    gr = GildedRose.new(name: "Conjured Mana Cake", days_remaining: -10, quality: 0)

    gr.tick

    expect(gr.days_remaining).to eq(-11)
    expect(gr.quality).to eq(0)
  end
end
