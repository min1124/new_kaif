require 'axlsx'
class DelayorderController < ApplicationController
	before_action :authentication

    def exampleDO
        if power(T_K3_Auth, "t_delayorder_auth")
            starttime = params[:starttime]
            endtime = params[:endtime]
            cpType = params[:cpType]

            sql = "";
            if cpType&&(""!=cpType)&&("all"!=cpType)
                sql += " and 类别 = '"+cpType+"'";
            end

            if endtime&&starttime&&(""!=endtime)&&(""!=starttime)
                @a = DelayOrder.find_by_sql("select * from G_DelayOrders 
                    where 查询日期 >= '"+starttime+"' and 查询日期 <='"+endtime+"'" + sql + " order by 查询日期 desc");
                render :json =>{:data =>@a}
            else
                @a = DelayOrder.find_by_sql("select * from G_DelayOrders 
                    where 查询日期 = convert(varchar(10),dateadd(day,-1,getdate()),120)" + sql + " order by 查询日期 desc");
                render :json =>{:data =>@a}
            end
        else
            return nopower!
        end
    end

    def examplePC
        if power(T_K3_Auth, "t_delayorder_auth")
            starttime = params[:starttime]
            endtime = params[:endtime]
            cpType = params[:cpType]

            sql = "";
            if cpType&&(""!=cpType)&&("all"!=cpType)
                sql += " and 产品类型 = '"+cpType+"'";
            end

            if endtime&&starttime&&(""!=endtime)&&(""!=starttime)
                @a = DelayOrder.find_by_sql("select * from G_ProductionCycles 
                    where 日期 >= '"+starttime+"' and 日期 <='"+endtime+"'" + sql + " order by 日期 desc");
                render :json =>{:data =>@a}
            else
                @a = DelayOrder.find_by_sql("select * from G_ProductionCycles 
                    where 日期 = convert(varchar(10),dateadd(day,-1,getdate()),120)" + sql + " order by 日期 desc");
                render :json =>{:data =>@a}
            end
        else
            return nopower!
        end
    end

    def getCpTypePY
        @a = DelayOrder.find_by_sql("select distinct 型号 from V_ProductionYield");
        render :json =>{:data =>@a}
    end

    def examplePY
        if power(T_K3_Auth, "t_delayorder_auth")
            starttime = params[:starttime]
            endtime = params[:endtime]
            cpType = params[:cpType]

            sql = "";
            if cpType&&(""!=cpType)&&("all"!=cpType)
                sql += " and 型号 = '"+cpType+"'";
            end

            if endtime&&starttime&&(""!=endtime)&&(""!=starttime)
                @a = DelayOrder.find_by_sql("select * from V_ProductionYield 
                    where 日期 >= '"+starttime+"' and 日期 <='"+endtime+"'" + sql + " order by 日期 desc");
                render :json =>{:data =>@a}
            else
                @a = DelayOrder.find_by_sql("select * from V_ProductionYield 
                    where 日期 > dateadd(month,-1,getdate())" + sql + " order by 日期 desc");
                render :json =>{:data =>@a}
            end
        else
            return nopower!
        end
    end

    def examplePCD
        if power(T_K3_Auth, "t_delayorder_auth")
            starttime = params[:starttime]
            endtime = params[:endtime]

            if endtime&&starttime&&(""!=endtime)&&(""!=starttime)
                @a = DelayOrder.find_by_sql("select * from V_ProductionCycleDay 
                    where 日期 >= '"+starttime+"' and 日期 <='"+endtime+"' order by 日期 desc");
                render :json =>{:data =>@a}
            else
                @a = DelayOrder.find_by_sql("select * from V_ProductionCycleDay 
                    where 日期 > dateadd(month,-1,getdate()) order by 日期 desc");
                render :json =>{:data =>@a}
            end
        else
            return nopower!
        end
    end

    def examplePD
        if power(T_K3_Auth, "t_delayorder_auth")
            starttime = params[:starttime]
            endtime = params[:endtime]

            if endtime&&starttime&&(""!=endtime)&&(""!=starttime)
                @a = DelayOrder.find_by_sql("select * from G_ProductionDay 
                    where 日期 >= '"+starttime+"' and 日期 <='"+endtime+"' order by 日期 desc");
                render :json =>{:data =>@a}
            else
                @a = DelayOrder.find_by_sql("select * from G_ProductionDay 
                    where 日期 > dateadd(month,-1,getdate()) order by 日期 desc");
                render :json =>{:data =>@a}
            end
        else
            return nopower!
        end
    end

    def exampleDOD
        if power(T_K3_Auth, "t_delayorder_auth")
            starttime = params[:starttime]
            endtime = params[:endtime]

            if endtime&&starttime&&(""!=endtime)&&(""!=starttime)
                @a = DelayOrder.find_by_sql("select * from G_DelayOrderDay 
                    where 查询日期 >= '"+starttime+"' and 查询日期 <='"+endtime+"' order by 查询日期 desc");
                render :json =>{:data =>@a}
            else
                @a = DelayOrder.find_by_sql("select * from G_DelayOrderDay 
                    where 查询日期 > dateadd(month,-1,getdate()) order by 查询日期 desc");
                render :json =>{:data =>@a}
            end
        else
            return nopower!
        end
    end

    def exampleDOC
        if power(T_K3_Auth, "t_delayorder_auth")
            cpType = params[:cpType]

            sql = "";
            if cpType&&(""!=cpType)&&("all"!=cpType)
                sql += "and 类别 = '"+cpType+"'";
            end

            @a = DelayOrder.find_by_sql("select * from V_DelayOderControl 
                where 查询日期 = convert(varchar(10),getdate(),120) " + sql + " order by 查询日期 desc");
            render :json =>{:data =>@a}
        else
            return nopower!
        end
    end

    def doExcel
        Axlsx::Package.new do |p|  
            p.workbook do |wb|  
                styles = wb.styles  
                header          = styles.add_style :fg_color=>"000000", :sz => 20, :b => true, :alignment => {:horizontal => :center}  
                center_header   = styles.add_style :sz => 12, :border => 1, :alignment => { :horizontal => :center }  
                item            = styles.add_style :sz => 12, :border => 1, :alignment => { :indent => 1 }  

                wb.add_worksheet(:name => "工作表1") do |sheet|  
                    sheet.add_row ['超15天未结工单明细'], :style => header 
                    sheet.add_row [nil]
                    sheet.add_row ['查询日期', '产品类型', '任务单号', '产品代码', '产品名称', 
                        '计划开工日期', '结案日期', '工单数量', '入库数量', '入库比'], :style => center_header 
                    inputsTbody = params[:inputsTbody]
                    a = 0;
                    if inputsTbody
                        a = inputsTbody.length;
                    end
                    for j in 0..a-1
                        tr = inputsTbody["#{j}"];
                        sheet.add_row [ tr["查询日期"], 
                                        tr["模块工单数"], tr["器件工单数"], tr["TO工单数"],  
                                        tr["模块未入库数"], tr["器件未入库数"], tr["TO未入库数"]
                        ], :style => item
                    end

                    %w(A1:J1 A2:J2).each { |range| sheet.merge_cells(range) }
                    sheet.column_widths 15, 15, 15, 15, 15, 15, 15, 15, 15, 15 
                end
            end  
            p.serialize 'public/超15天未结工单明细.xlsx'  
            render :text => "超15天未结工单明细.xlsx"
        end
    end

    def pcExcel
        Axlsx::Package.new do |p|  
            p.workbook do |wb|  
                styles = wb.styles  
                header          = styles.add_style :fg_color=>"000000", :sz => 20, :b => true, :alignment => {:horizontal => :center}  
                center_header   = styles.add_style :sz => 12, :border => 1, :alignment => { :horizontal => :center }  
                item            = styles.add_style :sz => 12, :border => 1, :alignment => { :indent => 1 }  

                wb.add_worksheet(:name => "工作表1") do |sheet|  
                    sheet.add_row ['生产周期统计明细'], :style => header 
                    sheet.add_row [nil]
                    sheet.add_row ['日期', '产品类型', '入库单号', '工单号', '产品代码', 
                        '产品名称', '领料时间', '入库时间', '入库数量', '单支周期(小时)'], :style => center_header 
                    inputsTbody = params[:inputsTbody]
                    a = 0;
                    if inputsTbody
                        a = inputsTbody.length;
                    end
                    for j in 0..a-1
                        tr = inputsTbody["#{j}"];
                        sheet.add_row [ tr["日期"], tr["产品类型"], tr["入库单号"], tr["工单号"],  
                                        tr["产品代码"], tr["产品名称"], tr["领料时间"],  
                                        tr["入库时间"], tr["入库数量"], tr["单支周期H"]
                        ], :style => item
                    end

                    %w(A1:J1 A2:J2).each { |range| sheet.merge_cells(range) }
                    sheet.column_widths 15, 15, 25, 15, 20, 30, 25, 25, 15, 15  
                end
            end  
            p.serialize 'public/生产周期统计明细.xlsx'  
            render :text => "生产周期统计明细.xlsx"
        end
    end

    def pyExcel
        Axlsx::Package.new do |p|  
            p.workbook do |wb|  
                styles = wb.styles  
                header          = styles.add_style :fg_color=>"000000", :sz => 20, :b => true, :alignment => {:horizontal => :center}  
                center_header   = styles.add_style :sz => 12, :border => 1, :alignment => { :horizontal => :center }  
                item            = styles.add_style :sz => 12, :border => 1, :alignment => { :indent => 1 }  

                wb.add_worksheet(:name => "工作表1") do |sheet|  
                    sheet.add_row ['良率日报'], :style => header 
                    sheet.add_row [nil]
                    sheet.add_row ['日期', '型号', '良率'], :style => center_header 
                    inputsTbody = params[:inputsTbody]
                    a = 0;
                    if inputsTbody
                        a = inputsTbody.length;
                    end
                    for j in 0..a-1
                        tr = inputsTbody["#{j}"];
                        sheet.add_row [ tr["日期"], tr["型号"], tr["良率"] ], :style => item
                    end

                    %w(A1:C1 A2:C2).each { |range| sheet.merge_cells(range) }
                    sheet.column_widths 15, 25, 15 
                end
            end  
            p.serialize 'public/良率日报.xlsx'  
            render :text => "良率日报.xlsx"
        end
    end

    def pcdExcel
        Axlsx::Package.new do |p|  
            p.workbook do |wb|  
                styles = wb.styles  
                header          = styles.add_style :fg_color=>"000000", :sz => 20, :b => true, :alignment => {:horizontal => :center}  
                center_header   = styles.add_style :sz => 12, :border => 1, :alignment => { :horizontal => :center }  
                item            = styles.add_style :sz => 12, :border => 1, :alignment => { :indent => 1 }  

                wb.add_worksheet(:name => "工作表1") do |sheet|  
                    sheet.add_row ['生产周期日报'], :style => header 
                    sheet.add_row [nil]
                    sheet.add_row ['日期', '模块周期', '器件周期', 'TO周期', '总周期' ], :style => center_header 
                    inputsTbody = params[:inputsTbody]
                    a = 0;
                    if inputsTbody
                        a = inputsTbody.length;
                    end
                    for j in 0..a-1
                        tr = inputsTbody["#{j}"];
                        sheet.add_row [ tr["日期"], tr["模块周期"], tr["器件周期"], tr["TO周期"],  
                                        tr["总周期"]
                        ], :style => item
                    end

                    %w(A1:E1 A2:E2).each { |range| sheet.merge_cells(range) }
                    sheet.column_widths 15, 15, 15, 15, 15  
                end
            end  
            p.serialize 'public/生产周期日报.xlsx'  
            render :text => "生产周期日报.xlsx"
        end
    end

    def pdExcel
        Axlsx::Package.new do |p|  
            p.workbook do |wb|  
                styles = wb.styles  
                header          = styles.add_style :fg_color=>"000000", :sz => 20, :b => true, :alignment => {:horizontal => :center}  
                center_header   = styles.add_style :sz => 12, :border => 1, :alignment => { :horizontal => :center }  
                item            = styles.add_style :sz => 12, :border => 1, :alignment => { :indent => 1 }  

                wb.add_worksheet(:name => "工作表1") do |sheet|  
                    sheet.add_row ['模块产量日报'], :style => header 
                    sheet.add_row [nil]
                    sheet.add_row ['日期', '产量'], :style => center_header 
                    inputsTbody = params[:inputsTbody]
                    a = 0;
                    if inputsTbody
                        a = inputsTbody.length;
                    end
                    for j in 0..a-1
                        tr = inputsTbody["#{j}"];
                        sheet.add_row [ tr["日期"], tr["产量"] ], :style => item
                    end

                    %w(A1:B1 A2:B2).each { |range| sheet.merge_cells(range) }
                    sheet.column_widths 15, 15  
                end
            end  
            p.serialize 'public/模块产量日报.xlsx'  
            render :text => "模块产量日报.xlsx"
        end
    end

    def dodExcel
        Axlsx::Package.new do |p|  
            p.workbook do |wb|  
                styles = wb.styles  
                header          = styles.add_style :fg_color=>"000000", :sz => 20, :b => true, :alignment => {:horizontal => :center}  
                center_header   = styles.add_style :sz => 12, :border => 1, :alignment => { :horizontal => :center }  
                item            = styles.add_style :sz => 12, :border => 1, :alignment => { :indent => 1 }  

                wb.add_worksheet(:name => "工作表1") do |sheet|  
                    sheet.add_row ['超15天未结工单日报'], :style => header 
                    sheet.add_row [nil]
                    sheet.add_row ['查询日期', '模块工单数', '器件工单数', 'TO工单数', '模块未入库数', 
                        '器件未入库数', 'TO未入库数'], :style => center_header 
                    inputsTbody = params[:inputsTbody]
                    a = 0;
                    if inputsTbody
                        a = inputsTbody.length;
                    end
                    for j in 0..a-1
                        tr = inputsTbody["#{j}"];
                        sheet.add_row [ tr["查询日期"], 
                                        tr["模块工单数"], tr["器件工单数"], tr["TO工单数"],  
                                        tr["模块未入库数"], tr["器件未入库数"], tr["TO未入库数"]
                        ], :style => item
                    end

                    %w(A1:G1 A2:G2).each { |range| sheet.merge_cells(range) }
                    sheet.column_widths 15, 15, 15, 15, 15, 15, 15  
                end
            end  
            p.serialize 'public/超15天未结工单日报.xlsx'  
            render :text => "超15天未结工单日报.xlsx"
        end
    end

    def docExcel
        Axlsx::Package.new do |p|  
            p.workbook do |wb|  
                styles = wb.styles  
                header          = styles.add_style :fg_color=>"000000", :sz => 20, :b => true, :alignment => {:horizontal => :center}  
                center_header   = styles.add_style :sz => 12, :border => 1, :alignment => { :horizontal => :center }  
                item            = styles.add_style :sz => 12, :border => 1, :alignment => { :indent => 1 }  

                wb.add_worksheet(:name => "工作表1") do |sheet|  
                    sheet.add_row ['超期工单监控'], :style => header 
                    sheet.add_row [nil]
                    sheet.add_row ['类别', '制造单号', '计划开工日期', '结案日期', '工单数量', 
                        '入库数量', '入库比'], :style => center_header 
                    inputsTbody = params[:inputsTbody]
                    a = 0;
                    if inputsTbody
                        a = inputsTbody.length;
                    end
                    for j in 0..a-1
                        tr = inputsTbody["#{j}"];
                        sheet.add_row [ tr["类别"], tr["制造单号"], tr["计划开工日期"], tr["结案日期"],  
                                        tr["工单数量"], tr["入库数量"], tr["入库比"]
                        ], :style => item
                    end

                    %w(A1:G1 A2:G2).each { |range| sheet.merge_cells(range) }
                    sheet.column_widths 15, 15, 15, 15, 15, 15, 15  
                end
            end  
            p.serialize 'public/超期工单监控.xlsx'  
            render :text => "超期工单监控.xlsx"
        end
    end
end