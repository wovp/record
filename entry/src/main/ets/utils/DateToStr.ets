export default function DateToStr(tt: Date){
    let ttt = tt.toLocaleString().split(',')[0]
    ttt = ttt.replace('时间', '')
    let tmp01 = ttt.split('/')
    let tmp0101 = tmp01[0]
    tmp01[0] = tmp01[2]
    tmp01[2] = tmp01[1]
    tmp01[1] = tmp0101


    ttt = ''+ tmp01[0] + '-' + tmp01[1] + '-' + tmp01[2]
    return ttt;
}