{%- set payment_methods = ['bank_transfer','credit_card','coupon','gift_card'] -%}
 
with payments as (
   select * from {{ ref('stg_stripe__payments') }}
),
 
final as (
   select
        order_id,
        {% for payment_method in payment_methods -%}
 
            sum(
                case when payment_method = '{{ payment_method }}'
                then amount
                else 0
                end) as {{ payment_method }}_amount
          
                {%- if not loop.last -%} -- True if last iteration
                    ,                    -- Para o for, garante que case when não termina em ,
                {% endif -%}             -- Assim código SQL não resulta em erro

       {%- endfor %}
   from payments
   group by 1
)
 
select * from final
