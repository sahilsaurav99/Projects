import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PermissionsGuard } from '../auth/guards/permissions.guard';
import { RequirePermissions } from '../auth/decorators/permissions.decorator';
import { TermsService } from './terms.service';
import { CreateTermDto } from './dto/create-term.dto';
import { ListTermsQueryDto } from './dto/list-terms.query';
import { UpdateTermDto } from './dto/update-term.dto';

/**
 * TermsController
 *
 * Permission keys mirror the subjects module:
 *   terms.read   | terms.create | terms.update
 *   terms.delete | terms.restore
 */
@ApiTags('Terms')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, PermissionsGuard)
@Controller({ path: 'terms', version: '1' })
export class TermsController {
  constructor(private readonly terms: TermsService) {}

  @Get()
  @RequirePermissions('terms.read')
  @ApiOperation({ summary: 'List terms (paginated, filterable).' })
  @ApiOkResponse({ description: 'Paginated list of terms.' })
  list(@Query() query: ListTermsQueryDto) {
    return this.terms.findAll(query);
  }

  @Get(':id')
  @RequirePermissions('terms.read')
  @ApiOperation({ summary: 'Get a single term by id.' })
  findOne(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.terms.findOne(id);
  }

  @Post()
  @RequirePermissions('terms.create')
  @ApiOperation({
    summary: 'Create a new term under an academic year.',
  })
  create(@Body() dto: CreateTermDto) {
    return this.terms.create(dto);
  }

  @Patch(':id')
  @RequirePermissions('terms.update')
  @ApiOperation({ summary: 'Update a term (partial).' })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateTermDto,
  ) {
    return this.terms.update(id, dto);
  }

  @Delete(':id')
  @RequirePermissions('terms.delete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft-delete a term (sets deletedAt).' })
  remove(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.terms.remove(id);
  }

  @Post(':id/restore')
  @RequirePermissions('terms.restore')
  @ApiOperation({ summary: 'Restore a previously soft-deleted term.' })
  restore(@Param('id', new ParseUUIDPipe()) id: string) {
    return this.terms.restore(id);
  }
}
