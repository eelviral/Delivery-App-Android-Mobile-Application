from __future__ import unicode_literals
from django.db import models


class Coordinates(models.Model):
    latitude            = models.DecimalField(max_digits=9, decimal_places=6, default=None)
    longitude           = models.DecimalField(max_digits=9, decimal_places=6, default=None)
    created             = models.DateTimeField(auto_now_add=True)
    updated             = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'{self.latitude}\n{self.longitude}'

    class Meta:
        ordering = ['-updated']
