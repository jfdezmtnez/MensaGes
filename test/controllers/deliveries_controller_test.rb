require "test_helper"

class DeliveriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @delivery = deliveries(:one)
  end

  test "should get index" do
    get deliveries_url
    assert_response :success
  end

  test "should get new" do
    get new_delivery_url
    assert_response :success
  end

  test "should create delivery" do
    assert_difference("Delivery.count") do
      post deliveries_url, params: { delivery: { courier_id: @delivery.courier_id, customer_id: @delivery.customer_id, delivered: @delivery.delivered, invoiced: @delivery.invoiced, pickup: @delivery.pickup, reimburse: @delivery.reimburse, tariff_id: @delivery.tariff_id } }
    end

    assert_redirected_to delivery_url(Delivery.last)
  end

  test "should show delivery" do
    get delivery_url(@delivery)
    assert_response :success
  end

  test "should get edit" do
    get edit_delivery_url(@delivery)
    assert_response :success
  end

  test "should update delivery" do
    patch delivery_url(@delivery), params: { delivery: { courier_id: @delivery.courier_id, customer_id: @delivery.customer_id, delivered: @delivery.delivered, invoiced: @delivery.invoiced, pickup: @delivery.pickup, reimburse: @delivery.reimburse, tariff_id: @delivery.tariff_id } }
    assert_redirected_to delivery_url(@delivery)
  end

  test "should destroy delivery" do
    assert_difference("Delivery.count", -1) do
      delete delivery_url(@delivery)
    end

    assert_redirected_to deliveries_url
  end
end
