#!/bin/bash

function ledsetup() {
    while true; do
        clear
        echo "板载 LED 控制器"
        echo "1. 关闭绿灯"
        echo "2. 绿灯闪烁"
        echo "3. 红灯闪烁"
        echo "4. 关闭红灯"
        echo "5. 绿灯常亮"
        echo "6. 红灯常亮"
        echo "7. 关闭所有灯"
        echo "8. 退出"
        read -p "请选择一个选项：" input

        case $input in
            1) echo "none" > /sys/class/leds/green_led/trigger && echo "绿灯已关闭";;
            2) echo "heartbeat" > /sys/class/leds/green_led/trigger && echo "绿灯设置为闪烁";;
            3) echo "heartbeat" > /sys/class/leds/red_led/trigger && echo "红灯设置为闪烁";;
            4) echo "none" > /sys/class/leds/red_led/trigger && echo "红灯已关闭";;
            5) echo "default-on" > /sys/class/leds/green_led/trigger && echo "绿灯设置为常亮";;
            6) echo "default-on" > /sys/class/leds/red_led/trigger && echo "红灯设置为常亮";;
            7) echo "none" > /sys/class/leds/red_led/trigger && echo "none" > /sys/class/leds/green_led/trigger && echo "所有灯已关闭";;
            8) echo "已退出"; break;;
            *) echo "输入错误";;
        esac
        echo "按任意键返回"
        read -n 1 -s keypress
    done
}

function jisuanqi() {
    while true; do
        clear
        echo "欢迎使用计算器！"
        echo "支持的运算符有：+, -, *, /"
        read -p "请输入您的算术表达式（例如：3 + 5）：" expression
        result=$(echo "scale=2; $expression" | bc)
        echo "结果是：$result"
        echo "按任意键返回主菜单"
        read -n 1 -s keypress
        break
    done
}

function wedtest() {
    clear
    echo "欢迎使用小工具，请输入网站:"
    read -p "请输入地址(带www.)：" website
    if ping -c 4 "$website" > /dev/null 2>&1; then
        echo "网站 $website 联通正常。"
    else
        echo "网站 $website 联通失败。"
    fi
    echo "按任意键返回主菜单"
    read -n 1 -s keypress
}
function gpioread() {
    clear
    echo "$ioid状态："
    local ioid_value_path="/sys/class/gpio/gpio$ioid/value"
    local zt  # 声明局部变量 zt

    # 读取GPIO状态并存储到变量 zt
    zt=$(cat "$ioid_value_path")

    # 使用case语句判断zt的值，并打印相应的信息
    case $zt in
    0) echo "关闭,按下任意键返回" && read -n 1 -s keypress;;
    1) echo "开启,按下任意键返回" && read -n 1 -s keypress;;
    *) echo "未知状态,按下任意键返回" && read -n 1 -s keypress;;
    esac
}
function gpior() {
    local ioid
    clear
    echo "欢迎使用 GPIO 读取工具，请输入要读取的 GPIO ID:"
    read -p "具体请参考官方文档，请输入ID:"  GPIO_PIN 

echo $GPIO_PIN > /sys/class/gpio/export

# 设置GPIO引脚为输入模式
echo "in" > /sys/class/gpio/gpio$GPIO_PIN/direction

# 读取并输出GPIO状态
GPIO_VALUE=$(cat /sys/class/gpio/gpio$GPIO_PIN/value)
echo "GPIO$GPIO_PIN is $GPIO_VALUE"

# 取消导出GPIO引脚
echo $GPIO_PIN > /sys/class/gpio/unexport
echo "按任意键返回"
read -n 1 -s keypress
break
}
function gpiosent() {

    local ioid
    clear
    echo "欢迎使用 GPIO 控制工具，请输入要控制的 GPIO ID:"
    read -p "具体请参考官方文档，请输入ID:" ioid
    echo $ioid > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio$ioid/direction
    while true; do
        clear
        echo "GPIO 控制器"
        echo "1. 打开 GPIO"
        echo "2. 关闭 GPIO"
        echo "3. 输出 GPIO 状态"
        echo "4. 退出"
        read -p "请选择一个选项:" input

        case $input in
           1) echo 1 > /sys/class/gpio/gpio$ioid/value && echo "GPIO $ioid 已打开, 按任意键返回" && read -n 1 -s keypress;;
2) echo "0" > /sys/class/gpio/gpio$ioid/value && echo "GPIO $ioid 已关闭, 按任意键返回" && read -n 1 -s keypress;;
            3) gpioread;;
            4) echo "已退出"; break;;
            *) echo "输入错误，请按任意键继续"; read -n 1 -s keypress;;
        esac
    done
}
function gpioctrl() {
clear
    echo "gpio小工具"
    echo "1.读取"
    echo "2.输出"
    echo "3.退出"
    read -p "请选择一个选项：" gpx

    # 修正后的case语句
    case $gpx in
        1) gpior;;
        2) gpiosent;;
        3) break;;  # 这里break后面只需要一个分号
      *) echo "输入错误，按下任意键返回" && read -n 1 -s keypress;;
    esac
}

function tim() {
clear
#!/bin/bash
echo "欢迎使用出题程序，请输入导出的文件名"
read -p "请输入导出文件名：" fileid
# 创建或清空文件
> $fileid
echo "请输入出题个数"
read -p "题目个数：" many
# 循环100次生成题目
for (( i=1; i<=many; i++ )); do
    # 随机生成分子和分母
    a=$((RANDOM % 10 + 1))
    b=$((RANDOM % 10 + 1))
    c=$((RANDOM % 10 + 1))
    d=$((RANDOM % 10 + 1))

    # 随机选择运算符
    operatorSign=$((RANDOM % 2))
    if [ $operatorSign -eq 0 ]; then
        operatorSign="+"
    else
        operatorSign="-"
    fi

    # 写入题目到文件
    echo "    $a           $c" >> $fileid
    echo "$i.  ——  $operatorSign —— =" >> $fileid
    echo "    $b           $d" >> $fileid
    echo "" >> $fileid
done

# 打印完成信息
echo "出题完成，请查看"
 echo "按任意键返回主菜单"
    read -n 1 -s keypress
    break
}
function isroot() {
    clear
if [ "$(id -u)" -ne 0 ]; then
    echo "当前非root账户运行"
else
echo "当前账户为root"
fi
echo "按任意键返回主菜单"
    read -n 1 -s keypress
    break
}
function wifis() {
    clear
echo "当前扫描到的WiFi："
nmcli d wifi list  # 列出所有可用的无线网络
echo "按任意键返回主菜单"
    read -n 1 -s keypress
    break
}
function apst() {
    clear
    echo "请输入WiFi信息"
    read -p"WiFi名：" id
    read -p"WiFi密码：" password
sudo create_ap -m nat wlan0 eth0 $id $password --no-virt
echo "按任意键返回主菜单"
    read -n 1 -s keypress
    break
}
function main_menu() {
    while true; do
        clear
        echo "Linux 小工具合集"
        echo "1. 灯光控制"
        echo "2. 计算器"
        echo "3. 联网测试"
        echo "4. GPIO 控制"
        echo "5. 分数出题器"
        echo "6. 用户判断"
        echo "7. 重启"
        echo "8.WIFI扫描"
        echo "9.热点"
         echo "10.退出"
        read -p "请选择一个选项：" input

        case $input in
            1) ledsetup ;;
            2) jisuanqi ;;
            3) wedtest ;;
            4) gpioctrl ;;
            5) tim;;
            6)isroot;;
            7)reboot;;
            8)wifis ;;
            9)apst;;
            10)clear; echo "感谢使用，再见！"; exit 0 ;;
            *) echo "输入错误，按任意键返回"; read -n 1 keypress;;
        esac
    done
}

# 脚本执行入口
main_menu