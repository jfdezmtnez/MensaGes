require "application_system_test_case"

class TariffsTest < ApplicationSystemTestCase
  setup do
    @tariff = tariffs(:one)
  end

  test "visiting the index" do
    visit tariffs_url
    assert_selector "h1", text: "Tariffs"
  end

  test "should create tariff" do
    visit tariffs_url
    click_on "New tariff"

    fill_in "Description", with: @tariff.description
    fill_in "Distance", with: @tariff.distance
    fill_in "Duration", with: @tariff.duration
    fill_in "Price", with: @tariff.price
    fill_in "Weight", with: @tariff.weight
    click_on "Create Tariff"

    assert_text "Tariff was successfully created"
    click_on "Back"
  end

  test "should update Tariff" do
    visit tariff_url(@tariff)
    click_on "Edit this tariff", match: :first

    fill_in "Description", with: @tariff.description
    fill_in "Distance", with: @tariff.distance
    fill_in "Duration", with: @tariff.duration.to_s
    fill_in "Price", with: @tariff.price
    fill_in "Weight", with: @tariff.weight
    click_on "Update Tariff"

    assert_text "Tariff was successfully updated"
    click_on "Back"
  end

  test "should destroy Tariff" do
    visit tariff_url(@tariff)
    click_on "Destroy this tariff", match: :first

    assert_text "Tariff was successfully destroyed"
  end
end
