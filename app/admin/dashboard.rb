ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    orders = Order.all
    orders.each do |order|
      user = User.find(order.user_id)
      panel "Invoice for #{user.fname} #{user.lname}" do
        ul style: "list-style-type: none;" do
          li "#{user.fname} #{user.lname}"
          li "#{user.address}"
          li "#{user.pcode}"
          li "#{user.email}"
          para "\n"
        end

        items = MovieOrder.where(order_id: order.id)
        s_total = 0

        ul style: "list-style-type: none;" do
          items.each do |item|
            s_total += (item.price * item.quantity)
            li "#{Movie.find(item.movie_id).title}..................................#{item.quantity} x $#{item.price} = $#{item.price * item.quantity}"
          end
        end

        ul style: "list-style-type: none;" do
          li "\nSubtotal    : $#{s_total} "
          li "PST (#{order.pst * 100}%)  : $#{(order.pst * s_total).round(2)}"
          li "GST (#{0.05 * 100}%)  : $#{(0.05 * s_total).round(2)}"
          li "Grand Total : $#{order.total} "
        end
      end
    end

  end
end
