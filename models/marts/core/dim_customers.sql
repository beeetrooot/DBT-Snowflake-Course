with customers as (
    select * from {{ ref('stg_customers')}}
),

orders as (
    select * from {{ ref('fct_orders')}}
),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value

    from orders

    group by customer_id

),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        t.first_order_date,
        t.most_recent_order_date,
        coalesce(t.number_of_orders, 0) as number_of_orders,
        t.lifetime_value

    from customers

    left join customer_orders t using (customer_id) 
)

select * from final