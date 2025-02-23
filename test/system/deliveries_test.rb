require "application_system_test_case"

class DeliveriesTest < ApplicationSystemTestCase
  setup do
    @delivery = deliveries(:one)
  end

  test "visiting the index" do
    visit deliveries_url
    assert_selector "h1", text: "Deliveries"
  end

  test "should create delivery" do
    visit deliveries_url
    click_on "New delivery"

    fill_in "Courier", with: @delivery.courier_id
    fill_in "Customer", with: @delivery.customer_id
    fill_in "Delivered", with: @delivery.delivered
    check "Invoiced" if @delivery.invoiced
    fill_in "Pickup", with: @delivery.pickup
    check "Reimburse" if @delivery.reimburse
    fill_in "Tariff", with: @delivery.tariff_id
    click_on "Create Delivery"

    assert_text "Delivery was successfully created"
    click_on "Back"
  end

  test "should update Delivery" do
    visit delivery_url(@delivery)
    click_on "Edit this delivery", match: :first

    fill_in "Courier", with: @delivery.courier_id
    fill_in "Customer", with: @delivery.customer_id
    fill_in "Delivered", with: @delivery.delivered.to_s
    check "Invoiced" if @delivery.invoiced
    fill_in "Pickup", with: @delivery.pickup.to_s
    check "Reimburse" if @delivery.reimburse
    fill_in "Tariff", with: @delivery.tariff_id
    click_on "Update Delivery"

    assert_text "Delivery was successfully updated"
    click_on "Back"
  end

  test "should destroy Delivery" do
    visit delivery_url(@delivery)
    click_on "Destroy this delivery", match: :first

    assert_text "Delivery was successfully destroyed"
  end
end
