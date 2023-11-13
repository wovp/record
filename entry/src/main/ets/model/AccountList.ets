/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import recordItem from './recordItem';

export const PayList: Array<recordItem> = [
  {
    icon: $rawfile('icon_food.png'),
    iconSelected: $rawfile('foods_selected.png'),
    accountType: 0,
    typeText: '吃饭'
  },
  {
    icon: $rawfile('icon_shopping.png'),
    iconSelected: $rawfile('snacks_selected.png'),
    accountType: 0,
    typeText: '购物'
  },
  {
    icon: $rawfile('icon_fuel.png'),
    iconSelected: $rawfile('fuel_selected.png'),
    accountType: 0,
    typeText: '汽车加油'
  },
  {
    icon: $rawfile('icon_study.png'),
    iconSelected: $rawfile('travel_selected.png'),
    accountType: 0,
    typeText: '教育'
  },
  {
    icon: $rawfile('icon_entertainment.png'),
    iconSelected: $rawfile('games_selected.png'),
    accountType: 0,
    typeText: '娱乐'
  },
  {
    icon: $rawfile('icon_tour.png'),
    iconSelected: $rawfile('pets_selected.png'),
    accountType: 0,
    typeText: '旅行'
  },
  {
    icon: $rawfile('icon_clothes.png'),
    iconSelected: $rawfile('app_selected_yifu.png'),
    accountType: 0,
    typeText: '衣服'
  },
  {
    icon: $rawfile('icon_medicine.png'),
    iconSelected: $rawfile('app_selected_yiliao.png'),
    accountType: 0,
    typeText: '医疗服务'
  },
  {
    icon: $rawfile('icon_other.png'),
    iconSelected: $rawfile('app_selected_qita.png'),
    accountType: 0,
    typeText: '其他'
  },
]

export const EarnList: Array<recordItem> = [
  {
    icon: $rawfile('income.png'),
    iconSelected: $rawfile('income_selected.png'),
    accountType: 1,
    typeText: '工作收入'
  },
  {
    icon: $rawfile('invest.png'),
    iconSelected: $rawfile('invest_selected.png'),
    accountType: 1,
    typeText: '投资'
  },
  {
    icon: $rawfile('invest.png'),
    iconSelected: $rawfile('invest_selected.png'),
    accountType: 1,
    typeText: '奖学金'
  },
  {
    icon: $rawfile('invest.png'),
    iconSelected: $rawfile('invest_selected.png'),
    accountType: 1,
    typeText: '幸运'
  },
]

export const ImageList: Record<string,Resource> = {
  '吃饭': $rawfile('icon_food.png'),
  '购物': $rawfile('icon_shopping.png'),
  '汽车加油': $rawfile('icon_fuel.png'),
  '旅游': $rawfile('icon_tour.png'),
  '娱乐': $rawfile('icon_entertainment.png'),
  '教育': $rawfile('icon_study.png'),
  '医疗服务': $rawfile('icon_medicine.png'),
  '衣服': $rawfile('app_yifu.png'),
  '其他': $rawfile('app_qita.png'),
  '工作收入': $rawfile('income.png'),
  '投资': $rawfile('invest.png')
}