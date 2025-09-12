package com.mideaibp.mibp.basic.dict.client.enums;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

/**
 * 国际化语言
 *
 * @author xionglei12
 **/
@Getter
public enum I18nLangEnum {
    /**
     * 简体中文
     */
    SIMPLIFIED_CHINESE("zh_CN", "简体中文"),
    /**
     * 英语
     */
    ENGLISH("en_US", "英语"),
    /**
     * 繁体中文
     */
    TRADITIONAL_CHINESE("zh_TW", "繁体中文"),
    /**
     * 阿拉伯语
     */
    ARABIC("ar_SA", "阿拉伯语"),
    /**
     * 西班牙语
     */
    SPANISH("es_ES", "西班牙语"),
    /**
     * 土耳其语
     */
    TURKISH("tr_TR", "土耳其语"),
    /**
     * 葡萄牙语
     */
    PORTUGUESE("pt_PT", "葡萄牙语"),
    /**
     * 韩语
     */
    KOREAN("ko_KR", "韩语"),
    /**
     * 俄语
     */
    RUSSIAN("ru_RU", "俄语"),
    /**
     * 意大利语
     */
    ITALIAN("it_IT", "意大利语"),
    /**
     * 波兰语
     */
    POLISH("pl_PL", "波兰语"),
    /**
     * 法语
     */
    FRENCH("fr_FR", "法语"),
    /**
     * 德语
     */
    GERMAN("de_DE", "德语"),
    /**
     * 越南语
     */
    VIETNAMESE("vi_VN", "越南语"),
    /**
     * 希腊语
     */
    GREEK("el_GR", "希腊语"),
    /**
     * 希伯来语
     */
    HEBREW("he_IL", "希伯来语"),
    /**
     * 罗马尼亚语
     */
    ROMANIAN("ro_RO", "罗马尼亚语"),
    /**
     * 匈牙利语
     */
    HUNGARIAN("hu_HU", "匈牙利语"),
    /**
     * 捷克语
     */
    CZECH("cs_CZ", "捷克语"),
    /**
     * 泰语
     */
    THAI("th_TH", "泰语"),
    /**
     * 格鲁吉亚语
     */
    GEORGIAN("ka_GE", "格鲁吉亚语"),
    /**
     * 丹麦语
     */
    DANISH("da_DK", "丹麦语"),
    /**
     * 芬兰语
     */
    FINNISH("fi_FI", "芬兰语"),
    /**
     * 荷兰语
     */
    DUTCH("nl_NL", "荷兰语"),
    /**
     * 乌克兰语
     */
    UKRAINIAN("uk_UA", "乌克兰语"),
    /**
     * 克罗地亚语
     */
    CROATIAN("hr_HR", "克罗地亚语"),
    /**
     * 瑞典语
     */
    SWEDISH("sv_SE", "瑞典语"),
    /**
     * 斯洛文尼亚语
     */
    SLOVENIAN("sl_SI", "斯洛文尼亚语"),
    /**
     * 斯洛伐克语
     */
    SLOVAK("sk_SK", "斯洛伐克语"),
    ;

    private final String code;

    private final String desc;

    I18nLangEnum(String code, String desc) {
        this.code = code;
        this.desc = desc;
    }

    public static I18nLangEnum getByCode(String code) {
        for (I18nLangEnum value : values()) {
            if (value.code.equals(code)) {
                return value;
            }
        }
        return null;
    }


    public static I18nLangEnum getByValue(String desc) {
        for (I18nLangEnum value : values()) {
            if (value.desc.equals(desc)) {
                return value;
            }
        }
        return null;
    }

}
