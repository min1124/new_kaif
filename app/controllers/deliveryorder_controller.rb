#require 'writeexcel'
require 'axlsx'
class DeliveryorderController < ApplicationController
    def test_excel
        Axlsx::Package.new do |p|  
            p.workbook do |wb|  
                styles = wb.styles  
                header          = styles.add_style :fg_color=>"000000", :sz => 20, :b => true, :alignment => {:horizontal => :center}  
                tbl_header      = styles.add_style :bg_color=>"99FF33",:b => true, :alignment => { :horizontal => :center }  
                left_header     = styles.add_style :sz => 16, :alignment => {:indent => 1}  
                center_header   = styles.add_style :sz => 12, :border => 1, :alignment => { :horizontal => :center }  
                item            = styles.add_style :sz => 12, :border => 1, :alignment => { :indent => 1 }  
                footer          = styles.add_style :sz => 12, :border => 1, :alignment => { :horizontal => :right }

                wb.add_worksheet(:name => "Basic Worksheet") do |sheet|  
                    sheet.add_row ['武汉烽火通信科技股份有限公司系统设备制造部交货单'], :style => header 
                    sheet.add_row [nil]
                    sheet.add_row ['供应商：武汉正源光子技术有限公司'], :style => left_header 
                    sheet.add_row [nil]
                    sheet.add_row ['No', '合同号', '行号', '烽火物料号', '物料描述', '箱号', '每箱数量', 
                                    '总数量', '备注', '产品批号'], :style => center_header 
                    inputsTbody = params[:inputsTbody]
                    a = 0;
                    if inputsTbody
                        a = inputsTbody.length;
                    end
                    for j in 0..a-1
                        #0->4;1->5
                        tr = inputsTbody["#{j}"];
                        sheet.add_row [(1+j).to_s, tr["hth"], tr["hh"], tr["wldm"], 
                                        tr["wlms"], tr["xh"]+"/"+tr["xs"], tr["mxsl"], 
                                        tr["zsl"], tr["bz"], tr["cpph"]
                        ], :style => item
                    end
                    inputsTfoot=params[:inputsTfoot]
                    sheet.add_row [nil,nil,nil,nil,"总箱数：",inputsTfoot["zxs"],"合计：",inputsTfoot["hj"],nil,nil], :style => [footer,footer,footer,footer,footer,item,footer,item,footer,footer]
                    sheet.add_row ["收货人：",nil,nil,nil,nil,nil,nil,nil,nil,nil], :style => footer  
                    sheet.add_row ["日期：",nil,nil,nil,nil,"日期：",nil,nil,nil,nil], :style => footer#[footer,nil,nil,nil,nil,footer]
                    #footer在a+7行

                    last_second_row = a+7
                    sheet.merge_cells "A#{last_second_row}:B#{last_second_row}"
                    sheet.merge_cells "C#{last_second_row}:J#{last_second_row}"

                    last_row = a+8
                    sheet.merge_cells "A#{last_row}:B#{last_row}"
                    sheet.merge_cells "C#{last_row}:E#{last_row}"
                    sheet.merge_cells "F#{last_row}:G#{last_row}"
                    sheet.merge_cells "H#{last_row}:J#{last_row}"

                    %w(A1:J1 A2:J2 A3:J3 A4:J4).each { |range| sheet.merge_cells(range) }
                    sheet.column_widths 6, 16, 7, 15, 16, 8, 12, 10, 11, 11  
                end
            end  
            p.serialize 'public/fh.xlsx'  
            render :text => "fh.xlsx"
        end
    end

    def ckdhChange
        ckdh = params[:ckdh]
        @a=Fbillno_Closed.find_by_sql("select t1.FBillNo 出库单号,t1.FHeadSelfB0166 as 合同号,
                    t2.FEntrySelfB0170 as 行号,t2.FMapNumber as 物料号,t2.FMapName as 物料描述,
                    t2.FQty as 总数量,t1.FHeadSelfB0162 as 备注
                    from srv_lnk.AIS20090714202245.dbo.ICStockBill t1 
                    left join srv_lnk.AIS20090714202245.dbo.ICStockBillEntry t2 on t1.FInterID = t2.FInterID
                    where t1.FBillNo = '"+ckdh+"'");
            render :json =>{:data =>@a}
    end
end