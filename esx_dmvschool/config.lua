Config = {}

Config.DMVSchool = {
    vector3(240.7489, -1379.575, 33.74177)
}

Config.Language = "en"

Config.SpeedMultiplier = 3.6 -- 3.6 for kmh, 2.236936 for mph

Config.MaxErrors = 10 -- Max errors before fail

Config.MarkerSettings = {
    type = 2,
    size = vector3(1.0, 1.0, 1.0),
    color = vector3(255, 255, 255),
    rotate = false,
    dump = false
}

Config.PuntiMinimi = 5 -- Minimum points to pass the theory test

-- ATTENTION: Modifying the id after a user has already obtained a license causes them to be lost
Config.License = {
    {
        label = 'License A',
        id = 'drive_bike',
        img = 'bike.png',
        pricing = {
            theory = 3000,
            practice = 4000
        },
        vehicle = {
            model = 'faggio',
            coords = vector3(231.2591, -1392.982, 30.50785),
            heading = 144.40260314941,
            plate = "DMV1"
        }
    },
    {
        label = 'License B',
        id = 'drive',
        img = 'car.png',
        pricing = {
            theory = 3000,
            practice = 4000
        },
        vehicle = {
            model = 'blista',
            coords = vector3(231.2591, -1392.982, 30.50785),
            heading = 144.40260314941,
            plate = "DMV1"
        }
    },
    {
        label = 'License C',
        id = 'drive_truck',
        img = 'truck.png',
        pricing = {
            theory = 3000,
            practice = 4000
        },
        vehicle = {
            model = 'pounder',
            coords = vector3(231.2591, -1392.982, 30.50785),
            heading = 144.40260314941,
            plate = "DMV1"
        }
    }
}

Config.PracticeCoords = {
    [1] = {
        {
            coordinate = vector3(227.1181, -1399.691, 30.1),
            speedLimit = 50
        },
        {
            coordinate = vector3(183.7479, -1394.595, 29.05295),
            speedLimit = 50
        },
        {
            coordinate = vector3(210.3608, -1327.127, 29.16619),
            speedLimit = 50
        },
        {
            coordinate = vector3(217.6466, -1145.248, 29.3349),
            speedLimit = 50
        },
        {
            coordinate = vector3(83.13854, -1136.699, 29.15778),
            speedLimit = 50
        },
        {
            coordinate = vector3(55.52874, -1248.127, 29.34311),
            speedLimit = 50
        },
        {
            coordinate = vector3(82.69904, -1338.678, 29.3447),
            speedLimit = 50
        },
        {
            coordinate = vector3(131.4893, -1387.581, 29.28993),
            speedLimit = 50
        },
        {
            coordinate = vector3(220.603, -1445.61, 29.24681),
            speedLimit = 50
        },
        {
            coordinate = vector3(242.2584, -1536.136, 29.24705),
            speedLimit = 50
        },
        {
            coordinate = vector3(301.6448, -1523.68, 29.34156),
            speedLimit = 50
        },
        {
            coordinate = vector3(256.1726, -1445.458, 29.24207),
            speedLimit = 50
        },
        {
            coordinate = vector3(233.427, -1397.215, 30.5071),
            speedLimit = 50
        },
    }
}


Config.Question = {
    [1] = {
        {
            label = "رنگ عدم عبور در چراغ های راهنمایی و رانندگی چیست؟",
            options = {
                {
                    label = "قرمز",
                    correct = true
                },
                {
                    label = "سبز",
                    correct = false
                },
                {
                    label = "زرد",
                    correct = false
                }
            }
        },
        {
            label = "تابلوی مثلثی شکل تقدم چه چیزی را نشان می دهد؟",
            options = {
                {
                    label = "تقاطع سه طرفه",
                    correct = false
                },
                {
                    label = "حق تقدم",
                    correct = true
                },
                {
                    label = "یک طرفه بودن مسیر",
                    correct = false
                }
            }
        },
        {
            label = "خط های ممتد(بدون فاصله) به منظور سبقت در جاده های دو طرفه به چه معناست؟",
            options = {
                {
                    label = "خط اضطراری برای عبور نیروهای کمکی",
                    correct = false
                },
                {
                    label = "سبقت ممنوع",
                    correct = true
                },
                {
                    label = "محل عبور دوچرخه",
                    correct = false
                }
            }
        },
        {
            label = "سرعت مجاز در شهر چند کیلومتر بر ساعت است؟",
            options = {
                {
                    label = "50 km/h",
                    correct = true
                },
                {
                    label = "70 km/h",
                    correct = false
                },
                {
                    label = "90 km/h",
                    correct = false
                }
            }
        },
        {
            label = "تابلوهای مورد استفاده درجاده ها که علامت دوربین بر روی آن قرار دارد چه چیزی را بیان می کند؟",
            options = {
                {
                    label = "حداکثر سرعت مجاز 20 کیلومتر",
                    correct = false
                },
                {
                    label = "ورود ممنوع",
                    correct = false
                },
                {
                    label = "نزدیک شدن به دوربین های کنترل سرعت را هشدار می دهند",
                    correct = true
                }
            }
        },
        {
            label = "حداقل فاصله ایمن از خودروی جلویی چقدر است؟",
            options = {
                {
                    label = "یک متر",
                    correct = false
                },
                {
                    label = "فاصله ی 2 ثانیه ای",
                    correct = true
                },
                {
                    label = "نیم متری",
                    correct = false
                }
            }
        },
        {
            label = "راننده هنگام نزدیک شدن به تقاطع همسطح همزمان با عبور قطار چه باید بکند؟",
            options = {
                {
                    label = "سرعت خود را زیاد کند تا قبل از عبور قطار از تقاطع گذر کند",
                    correct = false
                },
                {
                    label = "در صورتی که قطار گذر کرد میتواند عبور کند",
                    correct = true
                },
                {
                    label = "بوق بزند و به عبور قطار توجه نکند",
                    correct = false
                }
            }
        },
        {
            label = "علامت توقف نشان دهنده چیست؟",
            options = {
                {
                    label = "ایست بازرسی",
                    correct = false
                },
                {
                    label = "الزام به توقف",
                    correct = true
                },
                {
                    label = "یک طرفه بودن مسیر",
                    correct = false
                }
            }
        },
        {
            label = "علامت با فلش رو به بالا چه چیزی را نشان می دهد؟",
            options = {
                {
                    label = "عبور ممنوع میباشد",
                    correct = false
                },
                {
                    label = "مسیر یک طرفه میباشد",
                    correct = true
                },
                {
                    label = "عبور فقط برای عابر پیاده",
                    correct = false
                }
            }
        },
        {
            label = "تابلو های دایره ای که بر روی آنها عدد نوشته شده است چه هستند؟",
            options = {
                {
                    label = "محدودیت سرعت را مشخص می کنند",
                    correct = true
                },
                {
                    label = "منطقه عبور نظامی",
                    correct = false
                },
                {
                    label = "حضور حیوانات وحشی",
                    correct = false
                }
            }
        }
    },
    [2] = {
        {
            label = "علامت ورود ممنوع به چه معناست؟",
            options = {
                {
                    label = "وجوب تقدم",
                    correct = false
                },
                {
                    label = "رد شدن ممنوع",
                    correct = true
                },
                {
                    label = "توقف ممنوع",
                    correct = false
                }
            }
        },
        {
            label = "راننده هنگام نزدیک شدن به یک تقاطع بدون علامت چه باید بکند؟",
            options = {
                {
                    label = "برای عبور سریع سرعت بگیرید",
                    correct = false
                },
                {
                    label = "بایستید، راه بدهید و با احتیاط ادامه دهید",
                    correct = true
                },
                {
                    label = "بوق خود را به صدا درآورید تا به سایر رانندگان هشدار دهید",
                    correct = false
                }
            }
        },
        {
            label = "علامت منحنی چپ خطرناک چه چیزی را نشان می دهد؟",
            options = {
                {
                    label = "نزدیکی به محل استراحت",
                    correct = false
                },
                {
                    label = "وجود تقاطع",
                    correct = false
                },
                {
                    label = "وجود یک خم خطرناک چپ",
                    correct = true
                }
            }
        },
        {
            label = "علامت سبقت ممنوع چه چیزی را نشان می دهد؟",
            options = {
                {
                    label = "سبقت گرفتن در هر شرایط ممنوع است",
                    correct = true
                },
                {
                    label = "متوقف نشدن",
                    correct = false
                },
                {
                    label = "انتهای بزرگراه",
                    correct = false
                }
            }
        },
        {
            label = "تابلوی گذرگاه عابر پیاده نشان دهنده چیست؟",
            options = {
                {
                    label = "عبور و مرور فقط برای دوچرخه مجاز است",
                    correct = false
                },
                {
                    label = "ممنوعیت عبور عابرین پیاده",
                    correct = false
                },
                {
                    label = "نقطه ای که عابران پیاده می توانند با خیال راحت از آنجا عبور کنند",
                    correct = true
                }
            }
        },
        {
            label = "تابلوی محدوده ترافیکی محدود نشان دهنده چیست؟",
            options = {
                {
                    label = "آغاز یک منطقه ترافیکی محدود",
                    correct = false
                },
                {
                    label = "انتهای یک پارکینگ",
                    correct = false
                },
                {
                    label = "انتهای منطقه ای که محدودیت های دسترسی در آن اعمال می شود",
                    correct = true
                }
            }
        },
        {
            label = "علامت راهنمایی و رانندگی بدون موتور نشان دهنده چیست؟",
            options = {
                {
                    label = "وجوب تقدم",
                    correct = false
                },
                {
                    label = "ممنوعیت تردد فقط برای کامیون ها",
                    correct = false
                },
                {
                    label = "ممنوعیت عبور و مرور برای کلیه وسایل نقلیه موتوری",
                    correct = true
                }
            }
        },
        {
            label = "وقتی یک راننده با چراغ زرد چشمک زن به چراغ راهنمایی نزدیک می شود چه باید بکند؟",
            options = {
                {
                    label = "برای عبور قبل از تغییر جهت سرعت دهید",
                    correct = false
                },
                {
                    label = "فقط در صورت وجود وسایل نقلیه از تقاطع توقف کنید",
                    correct = true
                },
                {
                    label = "بدون کاهش سرعت ادامه دهید",
                    correct = false
                }
            }
        },
        {
            label = "تابلوی ممنوعیت ورود عابر پیاده به چه معناست؟",
            options = {
                {
                    label = "ممنوعیت عبور و مرور فقط برای دوچرخه سواران",
                    correct = false
                },
                {
                    label = "عبور فقط برای عابران پیاده ممنوع است",
                    correct = true
                },
                {
                    label = "الزام عبور فقط با دوچرخه",
                    correct = false
                }
            }
        },
        {
            label = "علامت ممنوعیت عبور وسایل نقلیه یدک کش چه چیزی را نشان می دهد؟",
            options = {
                {
                    label = "عبور فقط برای وسایل نقلیه موتوری ممنوع است",
                    correct = false
                },
                {
                    label = "حمل و نقل برای وسایل نقلیه یدک کش ممنوع است",
                    correct = true
                },
                {
                    label = "الزام به یدک کشی تریلر",
                    correct = false
                }
            }
        }
    }
}

Config.Lang = {
    ['it'] = {
        ['speed_error'] = "Vai troppo veloce, rallenta!",
        ['open_dmv'] = "Premi ~INPUT_CONTEXT~ per aprire la scuola guida",
        ['dmv'] = "SCUOLA GUIDA",
        ['point'] = "PUNTEGGIO",
        ['error'] = "ERRORI",
        ['ok'] = "Avanti",
        ['start_theory'] = "Inizia il Test Teorico",
        ['theory_before'] = "Fai il test teorico",
        ['start_practice'] = "Inizia il Test Pratico",
        ['test_passed'] = "Test Passato!",
        ['already_done'] = "Hai già fatto questo test!",
        ['theory_success'] = "Congratulazioni, hai passato il test teorico, torna presto per il test pratico!",
        ['theory_error'] = "Ci dispiace comunicarti che non hai passato il test teorico, non demordere, torna presto più preparato e riprova il test!",
        ['practice_success'] = "Congratulazioni, hai passato il test pratico, sei ora un guidatore con la patente!",
        ['practice_error'] = "Ci dispiace comunicarti che non hai passato il test pratico, non demordere, torna presto più preparato e riprova il test!",
        ['money_error'] = "Non hai abbastanza soldi per fare questo test! Ti mancano %s€"
    },
    ['en'] = {
        ['speed_error'] = "You are going too fast, slow down!",
        ['open_dmv'] = "Press ~INPUT_CONTEXT~ to open the DMV",
        ['dmv'] = "DMV SCHOOL",
        ['point'] = "POINT",
        ['error'] = "Khata Haye Shoma:",
        ['ok'] = "Ok",
        ['start_theory'] = "Start the Theory Test",
        ['theory_before'] = "Take the theory test",
        ['start_practice'] = "Start the Practice Test",
        ['test_passed'] = "Test Passed!",
        ['already_done'] = "You have already done!",
        ['theory_success'] = "Azmoon Ayin Naame Shoma Movafaghiat Amiz Bood",
        ['theory_error'] = "Shoma Dar Azmoon Ayin Naame Raad Shodid",
        ['practice_success'] = "Azmoon Shoma Movafaghiat Amiz Bood Va Shoma Govahiname Ra Daryaft Kardid",
        ['practice_error'] = "Shoma Dar Azmoon Ghabool Nashodid, Lotfan Dobare Talash Konid",
        ['money_error'] = "Shoma Pool Kafi Nadarid"
    }
}

-- Functions --

onCompleteTheory = function(license)
    TriggerServerEvent('esx_dmv:givelicense', license) -- Give license to sql
end

onCompletePractice = function(license)
    TriggerServerEvent('esx_dmv:givelicense', license) -- Give license to sql
end